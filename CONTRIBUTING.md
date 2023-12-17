# Contributing Guide

## How to find things to do{#find-issues}

There are many ways to contribute and many ways you can find things to do:

* See the [Contribute page](https://superpractica.org/contribute) on the website.
* Find issues through the [Roadmap](https://superpractica.org/resources/roadmap).
* Find issues on the issue trackers.
* Open a "thread" (issue) on the [contributor forum](https://codeberg.org/superpractica/discussion) if you have skills you want to apply but aren't sure how to apply them.

Super Practica is developed according to its [theory](https://codeberg.org/superpractica/blueprint) and [roadmap](https://superpractica.org/resources/roadmap). Contributions that stray from the roadmap are unlikely to be accepted. For example, new features can be a maintainance burden and can make playing the game more cumbersome.

If you're not sure if your idea will fit the roadmap, then please open an issue in the relevant issue tracker and discuss your planned change.

It's generally a good idea to talk in issues to get clear on what you're doing first before hacking away at it.


## How to use git{#git}

You should setup and figure out how to use git. This guide will explain how to use git to interact with this project, but not the basics.

Some useful links:
* <https://git-scm.com/>
* <https://docs.codeberg.org/git/configuring-git/>
* (Link a general guide here later.)


## How to run tests with GUT{#gut}

After you have the project running in Godot, you should setup GUT to run tests.

1. Download GUT. The currently used version is 9.1.1. You can find it at <https://github.com/bitwes/Gut>.

2. Put GUT in superpractica/addons/gut.

3. In the Godot Editor, go to Project > Project Settings > Plugins, and click the checkbox to enable GUT.

4. Click GUT > Run All to run the tests.

All tests should pass, though you will need to make sure that the game window receives no inputs or else it will crash due to input interference. You might need to unplug controllers for this to work, for example.

Please tell me if a test is failing after you do this, if it isn't documented already.

Note that some tests are marked as "do not maintain". It doesn't matter if these pass or not. They can be commented out if they fail.


## Project structure{#project-structure}

It will help to know how the code is organized. The main directories in the Godot project are these:

* content (can reference [core] and [general])
* core (can reference [general], but not [content])
* general (does not reference [content] or [core])

[general] contains things to make development easier and can be reused in other games.

[core] contains the mechanical system of Super Practica, but isn't itself playable.

[content] contains level data and implements classes defined in [core].

The interface between [content] and [core] is managed by the "game_driver.gd" file in the content folder, which is an "AutoLoad". It contains statements that tell the system in [core] what content to load and run when the game starts.


## Branch structure{#branch-structure}

The git branches and workflow reflect the project structure. The main branches are these:

* main
* content-X (such as "content-2")

Changes to [core] go into main, and changes to [content] go into the newest content branch. Changes to [general] go into whichever branch they're used in.

The reason for this division is that content often breaks when the core it depends on is changed. To make changing each easier, the content branches freeze changes to [core], and the main branch can keep its content down to a minimum for testing purposes.

Periodically, a new content branch will branch off of main, and then content from the previous content branch will be moved to it. This could take major rewriting, or the new content could be written again from scratch to copy the old content. The important part is that the design and integration tests stay the same.

A side effect is that code quality for content (excluding tests) is especially unimportant. So beginning programmers might be interested in getting productive practice by programming content.

There might also be special "demo" branches to test out new things.


## Versions and compatibility{#versions}

Note that version numbers such as "v0.7.1" are purely player-facing and not developer-facing. They only indicate changes that players will be interested in like new levels, and not changes to the backend like whether it's built with Godot 3 or Godot 4.

Instead of versions, compatibility is indicated by content branches. It's common to change version-numbering from v1.0 to v2.0 to indicate that things built with these different versions are incompatible. But here, a new content-3 branch will indicate that content built to run with the core in the content-2 branch is incompatible.


## How to fork and make a pull request{#pull-request}

1. Fork the repository.

    Press the Fork button in Codeberg to fork the repository to your profile.

2. Clone your fork to make changes to it locally.

    Open the command line where you want your project folder to go. Then run this command:

        git clone FORK_REPO_URL

    The FORK_REPO_URL is obtained by copying it from the "HTTPS/SSH" URL on your fork in Codeberg.
    
3. Add upstream to pull updates from.

    In your project folder, run:

        git remote add upstream SOURCE_REPO_URL

    The SOURCE_REPO_URL is the "HTTPS/SSH" URL on the project you're forking, not on your fork.

4. Add a new topic branch to change things on.

    In your fork on Codeberg, navigate to the Branches tab and click the appropriate button to "Create new branch". You should branch from either main or content-X according to which you want to make changes to. You can call it something like "my-changes".
    
    You should expect to make new topic branches for every new pull request and to throw them away when they're accepted.

5. Prepare your local folder for changes.
    
    In your project folder run:
    
        git pull
        git checkout YOUR_BRANCH_NAME
        
    This updates your local folder to your new branch. Then run:

        git pull upstream SOURCE_BRANCH_NAME
        
    The SOURCE_BRANCH_NAME should be the original branch you branched off from, such as "main" or "content-2".
    
    This will update your local folder to match the current state of the project.
    
6. Make and commit changes in your local folder.

    [Please make sure tests pass by running GUT.](#gut)

    [Please read the DCO and sign-off your commits.](#certify)

7. After you're done making changes, push them to your fork.

    In your project folder, run:

        git push

    This updates your fork on Codeberg with your changes.

8. Make a pull request.

    On either the original or your fork on Codeberg, find and click New Pull Request. Set it to merge into the original branch on the original repo from your branch on your fork and click "New Pull Request" on the next page.

    Leave a comment explaining the change, reference issues, etc. After you're done, click "Create Pull Request".

9. Stick around to see what happens and discuss things.

    There may be conflicts or other changes to make before the pull request can be accepted.


## Certify that you have rights to your contribution{#certify}

For legal assurance, please read the [Developer Certificate of Origin
(DCO)](https://developercertificate.org/), make sure that you can certify the things in it, and "sign-off" on every commit you make.

You sign-off by adding the following to your commit messages. Your sign-off should match the git user and email associated with the commit. It's preferred but not necessary that you use your real identity instead of being anonymous.

    This is my commit message

    Signed-off-by: Your Name <your.name@example.com>

Git has a `-s` command line option to do this automatically:

    git commit -s -m 'This is my commit message'

If you forgot to do this and haven't pushed your changes to the remote
repository yet, you can amend your commit with the sign-off by running:

    git commit --amend -s

If you already pushed your changes, you can still certify this in your pull request comment, but it's better to sign-off in each commit.

Adding a "signed-off-by" statement like this means you have read and agree to the DCO.


## Code style guide{#code-style}

When writing in GDScript, follow [Godot's GDScript style guide](https://docs.godotengine.org/en/3.5/tutorials/scripting/gdscript/gdscript_styleguide.html). Super Practica doesn't follow Godot's style guide exactly, but comes close.

(Document style differences here later.)


## Follow design specifications{#design-specs}

The features and content of Super Practica are based on [theory](https://codeberg.org/superpractica/blueprint), so it's important that they're added according to design specifications rather than whatever seems nice in the moment (for the most part).

(Link the place to find design specifications here, when it exists.)

