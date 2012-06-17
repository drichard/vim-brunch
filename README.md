#A vim plugin for [brunch](http://brunch.io/)

Inspired by [vim-rails](https://github.com/tpope/vim-rails) this plugin makes navigating through your brunch projects a lot more comfortable. Besides an interface to the brunch command line it offers Ex commands to quickly move from one brunch file to one of its related files. 

Editing your model and want to have the corresponding unit test in a vertical split? Just go `:BVtest`.

##Installation

1. Preferred method: Vundle
  * Install [vundle](https://github.com/gmarik/vundle)
  * Add `Bundle 'drichard/vim-brunch'` to your vimrc

2. Manual installation
  * Download zip/tarball and extract contents into your .vim directory
  OR
  * Use git:

  ```
  git clone git://github.com/drichard/vim-brunch.git
  cd vim-brunch
  cp -R * ~/.vim
  ```

##Usage

vim-brunch expects that you start VIM inside the root folder of your brunch project. When a brunch project has been detected the following commands are available:

###:Bmodel [name]
Edits the model for the current module or opens the model with the optionally given name.

###:Bview [name]
Edits the view for the current module.

###:Bcontroller [name]
Edits the controller for the current module.

###:Btemplate [name]
Edits the template for the current module.

###:Bstyle [name]
Edits the stylesheet for the current module.

###:Btest
Edits the test for the current file. Inside a model this will open the unit test for a model, inside a view it opens the view\_test etc. Inside a template, for example, this command doesn't make much sense.

###:Bconfig
Opens the config file for the project.

###:Bindex
Opens index.html

###Hints
* When called without an argument the commands with an optional [name] argument will open the appropriate file based on the file in the current buffer. However, you can specify a module name if you like to open an unrelated module.
  
  ```
  Inside app/models/todo.coffee:
  :Bview
  -> Opens app/views/todo_view.coffee
  
  Inside app/application.coffee:
  :Bview todolist
  -> Opens app/views/todolist_view.coffee
  ```

* The navigation commands can also be called as `:BVmodel` or `:BSview` and will then open the file in a vertical or horizontal split window.

  ```
  :BStemplate user
  -> Opens app/views/templates/user.styl in horizontal split window.
  ```

* The plugin makes a lot of assumptions about how you name your files and where you put them. If you don't follow the brunch conventions all hell will break lose and nothing will work.


##Configuration

For now the plugin does not detect which brunch skeleton you are using, so by default it expects the standard directory structure and CoffeeScript, Handlebars, Stylus.
If you want to chage those settings, the following global variables are defined:

###g:brunch_path_app
default: 'app'

The directory of the app folder.

###g:brunch_path_test
default: 'test'

The directory of the test folder.

###g:brunch_ext_script
default: 'coffee'

The extension for script files.

###g:brunch_ext_stylesheet
default: 'styl'

The extension for stylesheets.

###g:brunch_ext_template 
default: 'hbs'

The extension for templates.

###Example:
```vimL
Inside your .vimrc:
" Use Javascript and less for brunch.
let g:brunch_ext_script = 'js'
let g:brunch_ext_stylesheet = 'less'
```

##TODO

* Detect brunch settings based config.coffee
* Add suport `gf` in `require './home_view'` statements
