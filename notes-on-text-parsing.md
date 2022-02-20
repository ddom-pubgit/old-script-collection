# Introduction

So awhile back I wrote that it's not a great idea to muck about with text since strings are the devil and what-not. I stand by this, but
at the same time, it feels like giving strings a bit too much power over me, so I decided I want to parse a log file. This is generally a
bad idea but so are most things I do, so this is really not different.

## Preparation

Like with most tools I write, I have a few implicit goals in mind:

- Must be runnable anywhere on any machine without any dependencies our colleagues cannot expect to have
- Must be runnable with bare-minimum knowledge of scripting in general
- Should not require manual edits of variables/line entries (e.g., the script should take an input and do the rest)
- The script should tell you what you did wrong
- Easy to maintain across Veeam versions
- Does not depend on version specifics

Pay careful attention to those last two points, cause holy shit did I mess the bed on those two here, and it's simply because parsing text
is Hard with a capital H.

## Scenario

I wanted a tool that could look at Utils/VMC.log and tell me if the customer is over-subscribing (provisioning) their environment. The tool
should have a very simple workflow:

1. Get a full Infrastructure Item Collection run from the VMC log, and warn if this log doesn't have a full run
2. Get a list of all Hosts, Proxies, Repos, and Tape Servers
3. Convert these items from 2 into Objects
4. Output an analysis which checks to see which hosts are used for what Infrastructure Roles and ensure they meet our System Requirements

Not being a customer facing script, I felt this was a pretty good place to start and I began with a bit of research as I just wasn't
familiar on how Powershell could handle parsing text. A doubtful part of my mind said "Do this in a real language", but I am lazy and
wanted to do it in Powershell. Maybe people could learn a bit from it, or at least I suggested this to myself.

## Challenges

For me it helps to break down the item I'm working on into the challenges I foresee and what needs to be overcome or that I need to learn
to get better at. Some one-off scripts I can write without thinking about it, others I need to test and play a little.

The challenges I saw were as follows:

1. I don't exactly know how to get a "full" run from VMC; VMC can be interrupted during log collection and we can have incomplete entries,
so I needed to find a way to ensure that what I grabbed from VMC was complete.
2. There are many "sections" to VMC, and isolating them I wasn't quite sure about.
3. Getting text to Objects was going to be a pain in the ass; I knew this going into it, but for some reason felt ready to attack this.

The comparisons and analysis itself would be pretty simple, it was just getting the data into a compatible format to analyze which I was
not looking forward to.

# Starting from the Beginning

## Research

My research started just with an example text file to understand how I'd go about getting the relevant entries with minimal effort.
I didn't want to grab data with a lot of manual entires, for example, I wanted to avoid:

<pre><code>
$Somevariable = @()
$Somevariable.Add($SomeEntry)
$Somevariable.Add($SomeEntry2)
..
</code></pre>

This is too much manual entry and updating it for when VMC inevitably changes would be awful, as I'd have to check each section and look
for what changed and understand how to format it again.

So first, I wanted to know how to work and get items from text files in Powershell (PS from now on) and .NET (NET). The command
<code>Get-Content</code> seemed like it was going to be the ticket; NET classes to pull data from files didn't add a lot of benefit here
since we're not parsing a huge volume of data (VMC is predictably fairly small relatively speaking) so this was useful; I knew that using
<code>Get-Content</code> would result in a text array, cause that's just kind of what it does.

Suppose we fetched all of our VMC log text into the __$FileContent__ variable with the following:

<code>$FileContent = Get-Content -Path %Programdata%\Veeam\Backup\Utils\VMC.log</code>

i will refer to $FileContent for the remainder of the the article as the definitive source for all the VMC content.

What I wasn't quite sure of was finding the strings that indicated the start/end of a VMC run. With some research online, I found two overall approaches:

1. Set the <code>Type</code> for the content as a <code>List</code>
2. <code>Foreach</code> over the entire array as you would any other.

The 2nd point strikes me as not great, but I must admit in testing I could not find a difference in time/processing even on a larger file. The benefit of the 2nd method is that you don't have to do as much deductive work to know if you have a a valid run; that is, since we know the text strings that start and end the VMC log run __and__ we know they appear in order, you can assume the following (below is pseudocode):

<code>
$VMCStarts = $FileContent | Where-Object {$\_ -like "\*string that starts vmc\*"}
$VMCEnds = $FileContent | Where-Object {$\_ -like "\*string that ends vmc\*"}
</code>

Theoretically, the one with the largest difference in time value between Start and End should be a "real" run; even if there are multiple "real" runs, we still need to pick the most recent one, so with date information, you can parse on this by making a Powershell <code>Date Object with Get-Date -Date "text from the start/end entry"</code> and then you have convenient math with Date Objects.

Try it out now if you aren't sure what I mean here;
<code>
$date1 = Get-Date -Date "some date in whatever format"
$date2 = Get-Date -Date "some other date in the same format as $date1"
($date2 - $date1)
($date1 - $date2)
</code>

See how that works? This is a great example of using scripting to make your life a bit easier, and all it requires is some manipulation to get the strings for Dates out of the log entries. But, therein lies the annoyance; for sure I don't want to validate such things unless I have to! So I don't see a lot of value on this unless it's the only way forward.

So what about the 1st option? What does that really mean?

The Type matters a ton, since it potentially introduces different methods for us to use and to make our lives easier; my goal is fast searching through potentially a lot of lines of text without having to parse; do Lists give us any advantage here?

The answer is of course "yes". Let's see what we can maybe do with a list:

<code>
[Collections.Generic.List[Object]]$FileContent = Get-Content -Path "C:\Path\to\VMC.log"
$FirstEntry = $FileContent.FindLastIndex({$args[0] -like "\*Some string\*"})
$SecondEntry = $FileContent.FindLastIndex({$args[0] -like "\*Some other string\*"})
</code>

The above code finds the last index entry (number) that matches the condition of the method. The <code>FindLastIndex</code> has a sister, <code>FindIndex()</code> that does the opposite of her brother and finds the //first// index entry that matches the condition of the method.

For our condition, we use the <code>-like</code> operator to give us some flexibility in our search but we need to be careful; as I know that VMC has a lot of disparate data, I can't be sure that a simple match like "\*NFS\*" won't return both info on NFS repositories //and// vPowerNFS information; it's a simple regex match, and this just creates extra work if I'm not careful about what is matched.

But, why do we want the Index values in the first place? Maybe you can think about what the $FileContent really is and how this might help; seriously, stop for a moment and just think on what it is.

.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.

It's an array, right? And we know that we can call various sections of an array based on their number in the index; for example, let's assume we have the following array:

<code>
$CrummyArray = @("a","b","c","d","e")
</code>

Printing the array results in:

<code>
$CrummyArray
  a
  b
  c
  d
  e
</code>

Neat, right? But let's say we just wanted the last 3 letters? We could do:

<code>
$CrummyArray[2..4]
  c
  d
  e
</code>

Recall that arrays count from 0 and this makes more sense probably. You can even call specific elements from an array with comma separated values, e.g., <code>$CrummyArray[0,1,4]</code>. Test it out.

Warning! Make sure your called item actually fits in the array bounds! Make the above array and try doing <code>$CrummyArray[10]</code>. What happened? Does the error seem familiar?

So...we've talked a lot about arrays here, how would you go about making a full run of the VMC log?
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
.
In this case, I just ended up doing the following; maybe there's a faster way:

<code>
[Collections.Generic.List[Object]]$content = Get-Content "path to VMC" #Make Selector
$startingPointIndex = $content.FindLastIndex({$args[0] -like '\*STARTCOLLECTINFRASTATISTIC*'})

$lastlineIndex = $content.FindLastIndex({$args[0] -like "\*Veeam Metrics Collector stopped*"})
[Collections.Generic.List[Object]]$LastFullContent = $content[$startingPointIndex..$lastlineIndex]
</code>

Step by step, we:

1. Get the content of the VMC file
2. Set the Starting Point for our index for the last "full" run
3. Set the Ending Point for our index for the last "full" run
4. Then, create a List that is calling from the initial list with an index point of our desired start and our desired finish.

There is some flaw here as I'm assuming an incomplete run won't have the ending point, and also it fails with an incomplete run as the starting index point might not have a corresponding end point and the result is negative-math. As I was writing this, I just didn't have time to really test and get edge-cases for this to confirm/deny solutions. My guess is that we'll just end up switching to the <code>FindIndex()</code> method to get the first full run, but I feel this is also risky as it's not a guarantee that any run is complete! Keep this in mind as you write parsing script that you need to constantly re-evaluate your ideas and pre-conceived notions since you have no idea when you might have a "wrong" assumption.
