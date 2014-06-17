---
layout: post
title: The Github Syndrome
date: 2014-05-15 12:35:18
tags: software
category: english
comments: true
img_rel: "/~sven337/data/XXX"
---

Github is a great platform to host software and share it. It also has dangerous effects on the open source community, that tend to reduce software quality as well as my general pleasure of working with open source.

# Table of contents
{:.no_toc}

1. contents placeholder
{:toc}

# It was better before...

Although I can't disclose details, I am an experienced open source developer, having been the leader of a quite successful open source project for a decade. This project received contributions from hundreds of different people over the years. I was in fact a dictator, ensuring quality of code, releases at a satisfying frequency, and making sure contributors would learn and improve the quality of their work. Making a contribution to the project required producing good quality patches. Our notoriety as well as this quality ensured that no fork ever had any success, even though it was justified in some cases because some contributors had goals that ran against mine as a project leader.

Life as a contributor wasn't always easy, and getting a patch integrated was a significant reward for a significant amount of work - but that's the price of writing and distributing good software. Most contributors would give up, some of them would learn and go on to become better programmers, some of those would stay to work on the project for many years. That's the way traditional open source works, and that's what works.

# Traditional open source economics

In traditional open source, if a contributor produces sub-par work and still wants people to use it, he's got one way: create a fork, attempt to publicize it, and compete with the original project for users. This never works unless the *developers* of the original project jump ship - which only ever happens when leadership is *bad* **and** *too stupid to change*. 
(Everybody in a position of power becomes bad over time. I did. The developers called me out on that, after ten years of mostly good services on my part, and I stepped down because I'm not too stupid to recognize when my influence stops being positive. That's a story for another time, however.)

The practical consequence is that in traditional open source, a contributor cannot effectively distribute his changes without the agreement of the project's developers - and this agreement matters because the developers are the technical experts (most of the time) and they're the one doing support, so they know what will work and what will not. That is not to say that they cannot be wrong, but the following assertion holds:

**p(contributor_wrong) > p(developer_wrong)**

The only choices a contributor has are: 

- write good code that is accepted upstream and subsequently shipped and supported upstream
OR 
- not do anything at all

That's it, there is no third **distribute my crap for the world to see** option.

# Github's motto: Promote "Not Invented Here"

Github promotes this third option, by giving everybody a big button enabling them to publicize *whatever code they write*. I'll argue that making it easier to publish one's code is the exact opposite of what open source needs, if we as a community care about the quality of our code as well as the ease of joining our community.
No, open source isn't about publishing **one's code**, it's about publishing **software**, which is typically done as part of a team with different skills spread over different team members.

Giving an economical incentive to contributors to *not* work to get their code merged upstream has nefarious effects.

## Ignoring upstream objections


### Pull requests are good for Linux, not for your tiny project

With Github, forking is easy (it wasn't before). So **if upstream doesn't want your patch, nevermind!** Just publish it!
In fact, Github went so far as to change the *order* in which things are done: you would traditionally send your patch upstream, get it rejected, and then attempt to fork. Now, you fork immediately, and then possibly, if you feel like it, request upstream to integrate it by sending a "pull request". That's the opposite of the correct order!
Note that pull requests aren't the best way of getting changes reviewed - the best way is to use git-format-patch (or whatever equivalent) and send e-mail- or web-based review requests for each change. A pull request is good when you have a lot of already reviewed changes ready to go, in other words when you're an equal to upstream. You're usually not.

### Upstream knows better than you

See the title of this paragraph. This is a fundamental heuristic. It's not a fact, but it's true in 99% of cases, and even more so in the case of open source newbies - who, I submit to you should *not* be encouraged to publish their code by themselves just yet.

When upstream rejects your patch, there are four possible cases:

1. Your patch is technically incorrect. It will crash, or expose bugs in certain uses cases, not necessarily yours. 
1. Your patch is stylistically incorrect, making long terme maintenance harder.
1. Your patch is politically incorrect, in other words it runs counter to the project's objectives.
1. Your patch is correct and upstream is being stupid or not doing its job

The third case will justify a fork, but I'd only do it after I've confirmed that upstream leadership has wrong objectives. This happened only once in my long life in open source, and I didn't fork the project all by myself.
The fourth case happens sometimes, but the odds are very low. I almost never got a correct patch rejected. This happens most often when you're dealing with a *not-really-open-source project*, such as most projects backed by a commercial entity, where for various reasons they do not accept patches from the outside even though they claim they do. Examples abound but that would jeopardize my anonymity, so just imagine.

In the other two cases, objections from upstream are justified. Here is a nice little algorithm for you:

```basic
	10 UPSTREAM IS RIGHT
	20 YOU ARE WRONG
	30 GOTO 10
```

But thanks to my friends at Github, you can now ignore those objections with a single mouse click! Isn't it awesome: **nobody can prevent you from publishing buggy or unmaintainable code any longer**! 

## Fragmenting the hell out of an already complex world

Another issue with the Github mentality is that not only this encourages people to publish crap, instead of making actually good changes, it also fragments the market to an incredible extent.
Take the [RF24](https://github.com/maniacbug/RF24) library. It's a driver for the **nRF24L01+** radio transmitter that I like so much (mainly because its datasheet is what I would like to see for all ICs and computers). How many times was it forked? About once for *every fucking user on the planet*. How many of those users are competent enough to write low-level multiplatform code? ... That's what I thought.

Each fork made some changes:

- about 50% of them are pure crap that should never have seen the light of day (they will crash the chip, or the program)
- 25% are useless changes
- 20% are fixes to actual issues
- 5% are gold nuggets (dramatic performance improvements, ...)
   
For example, if you look at [one of the most recent forks](https://github.com/TMRh20/RF24), you have pretty much all of that. 

The real objective for our open source community should be to **throw away the 75% of crap** and useless changes, integrate the 20% of fixes, and promote (ie. make a new release for) the 5% of gold nuggets. What do we do in practice with Github? We publish **N different software solutions**, **none of which are fully working**, to the same problem.

## Not capitalizing knowledge

I am somewhat elitist, having reviewed thousands of changes in my life as an open source developer, and rejected easily 50% of them. Rejecting patches *makes contributors sad*, and they give up, and we as a community *lose valuable members*... right?
Well, **no**. Patches get rejected for a reason, and most of those that do come from beginners. I like newbies, because it gives me an opportunity to teach things, and to see people *make progress based on things you've taught them* is one of the *greatest reasons to live*.
Rejecting a patch must be done properly - think Greg KH rather than Linus Torvalds, taking particular care to newbie's feelings. Encourage them to improve and resubmit, help them do better work. Half of the newbies who get a patch rejected will *not update their patch* and will *leave forever*. Those are not valuable members, they were *potential* valuable members who turned out to be *spoiled kids* after all. The other half will improve and that's where your *good developers* come from.
But this teaching only happens because traditional open source forces inexperienced newbies to talk to - and convince - experienced developers. In Github, none of that - and everybody stays stupid in their corner instead of becoming smart together.

## Making me waste my time :)

As it turns out, for my RF24 + Raspberry Pi use, I had to merge fixes (and revert crap) from 4 different forks on Github. I'm still not done, because I lack the technical expertise with this chip and the library, and it's getting to the point where it would have been faster for me to write everything from scratch (because incidentally software drivers are *my core competency*).
So I'm playing catchup with the different forks, and not acquiring (nor sharing) knowledge. I'm spending my valuable time playing Frankenstein, assembling a somewhat working piece of software instead of contributing to an actually working, and maintained, project.

# But, Linux, blablabla

Had Linux been written in 2013, we'd have ten thousand "linux" repositories on Github, with no upstream merging path, and nobody would know what version to download and install. Bugs would not typically get fixed, and distributors would end up forking Linux for real, and maintaining incompatible code that would bear the same version number.
The Github spirit is open source without maintenance.

# I need you to save my open source community

Folks, let's do something about this. I don't have an easy solution, but let's at least agree that there's a problem and see what we can do about it - I'm not at all in favor of forbidding people to do whatever they please with code, but I long for the sense of high quality software that we used to have in open source.
