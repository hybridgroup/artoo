## Artoo Website

This site is build using [Middleman](http://middlemanapp.com/getting-started/)  
  
To run locally:  

      bundle install
      bundle exec middleman

### Deploy

[middleman-gh-pages](https://github.com/neo/middleman-gh-pages) gem is being used to build the webpage and deploy to gh-pages branch.  

For deploying the webpage, your must be in 'artoo.io' branch and run the following command:

      rake publish

### Documentation

If you want to help us with the documentation of the site, you can follow this steps :

- 1) Download the zip of the branch "artoo.io" or clone the project with git.

		  git clone https://github.com/hybridgroup/artoo.git "name"

- 2) Create a new branch for the project and switch to that new branch.

		  git branch "new_name"
		  git checkout "new_name"

- 3) Open the project with your favourite text editor.

- 4) Go to the file `source/documentation` , here is all the documentation of the site.

#### Platforms







