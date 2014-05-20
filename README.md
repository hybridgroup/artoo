## Artoo Website

This site is build using [Middleman](http://middlemanapp.com/basics/getting-started/)  
  
To run locally:  

      bundle install
      bundle exec middleman

### Deploy

[middleman-gh-pages](https://github.com/neo/middleman-gh-pages) gem is being used to build the webpage and deploy to gh-pages branch.  

For deploying the webpage, your must be in 'artoo.io' branch and run the following command:

      rake publish

You must not have any uncomitted or untracked files in the site dirs, or the publish operation will fail with a message such as `Directory not clean`.

If the publish fails, you might need to remove the `build` dir before trying to run `rake publish` again.

### Documentation

This project uses HAML.

If you want to help us with the documentation of the site, you can follow this steps :

- 1) Download the zip of the branch "artoo.io" or clone the project with git.

		  git clone https://github.com/hybridgroup/artoo.git "name"

- 2) Create a new branch for the project and switch to that new branch.

		  git branch "new_name"
		  git checkout "new_name"

- 3) Open the project with your favourite text editor.

- 4) Go to the file `source/documentation` , here is all the documentation of the site.

#### Platforms

To add new information to any platform, do this : 

- 1) Go to the file `source/documentation/platforms` , and select the platform you want to edit.

#### Drivers

To add new information to any driver, do this : 

- 1) Go to the file `source/documentation/drivers` , and select the driver you want to edit.

#### Examples

To import examples from the main Artoo repository, run the `bin/import_examples`
script. You'll need to have Git installed.

This script will:

- clone down the Artoo repo
- extract all examples
- create missing example pages and remove those that have also been removed from the main repo
- create/update examples index page

#### Repo Docs

To import docs partials from Artoo adaptor repositories, run the
`bin/import_repo_docs` script.

This script will:

- clone down Artoo adaptor repositories
- extract all `docs/*.md` documents
- add them as partials to `source/documentation/drivers/partials`

If you want to only import docs from a single repo:

```
bin/import_repo_docs hybridgroup/artoo-gpio
```

or

```
bin/import_repo_docs https://github.com/hybridgroup/artoo-gpio.git
```

### Send your Pull Request

When you have your code ready, create a new PR : `base: artoo.io` and `compare:"your_branch"`
