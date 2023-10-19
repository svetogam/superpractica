# Contributing Guide

## How to find things to do

There are many ways to contribute and many ways you can find things to do:

* See the [Contribute page](https://superpractica.org/contribute) on the website.
* Find issues through the [Roadmap](https://superpractica.org/resources/roadmap.md).
* Find issues on the issue trackers.
* Open a "thread" (issue) on the [contributor forum](https://codeberg.org/superpractica/discussion) if you have skills you want to apply but aren't sure how to apply them.

Super Practica is developed according to its [theory](https://codeberg.org/superpractica/blueprint) and [roadmap](https://superpractica.org/resources/roadmap.md). Contributions that stray from the roadmap are unlikely to be accepted. For example, new features can be a maintainance burden and can make playing the game more cumbersome.

If you're not sure if your idea will fit the roadmap, then please open an issue in the relevant issue tracker and discuss your planned change.

It's generally a good idea to talk in issues to get clear on what you're doing first before hacking away at it.


## How to use git

You should setup and figure out how to use [git](https://git-scm.com/). This guide will explain how to use git to interact with this project, but not the basics.

(Link general git guide here later.)

You can setup git however you want. Personally, I run git-cola to have a GUI for staging and commiting, and I run git in the command line for everything else.


## How to setup GUT

After you have the project running in Godot, you should setup GUT to run tests.

1. Download GUT. The currently used version is 7.4.1. You can find it at <https://github.com/bitwes/Gut>.

2. Put GUT in superpractica/addons/gut.

3. In the Godot Editor, go to Project > Project Settings > Plugins, and click the checkbox to enable GUT.

4. Click GUT > Run All to run the tests.

All tests should pass, though you will need to make sure that the game window receives no inputs or else it will crash due to input interference. You might need to unplug controllers for this to work, for example.

Please tell me if a test is failing after you do this, if it isn't documented already.


## How to fork and make a pull request

1. Fork the repository.

    Press the Fork button in Codeberg to fork the repository to your profile.

2. Clone your fork to make changes to it locally.

    Open the command line where you want your development folder to go. Then run this command:

        git clone FORK_REPO_URL

    The FORK_REPO_URL is obtained by copying it from the "HTTPS/SSH" URL on your fork in Codeberg.

3. Add upstream to pull updates to your fork.

    In the project folder, run:

        git remote add upstream SOURCE_REPO_URL

    The SOURCE_REPO_URL is the "HTTPS/SSH" URL on the project you're forking, not on your fork.

4. Push changes to your fork.

    After you commit changes to your local repository, in the project folder, run:

        git push

    Your fork on Codeberg should update with your changes.

5. Make a pull request.

    Please make sure all tests pass by running GUT before making a pull request. (But it's okay if tests marked as "do not maintain" fail.)

    On either the original or your fork on Codeberg, Click Pull Requests > New Pull Request. Make it merge into the original from your fork and click "New Pull Request" on the next page.

    Leave a comment explaining the change, reference issues, etc. After you're done, click "Create Pull Request".

6. Stick around to see what happens and discuss things.


## Certify that you have rights to your contribution

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


## Code style guide

When writing in GDScript, follow [Godot's GDScript style guide](https://docs.godotengine.org/en/3.5/tutorials/scripting/gdscript/gdscript_styleguide.html). Super Practica doesn't follow Godot's style guide exactly, but comes close.

(Document style differences here later.)

