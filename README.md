#A vim plugin for [brunch](http://brunch.io/) (with Backbone)

Inspired by [vim-rails](https://github.com/tpope/vim-rails) this plugin makes navigating through your brunch projects a lot more comfortable. Besides an interface to the brunch command line it offers Ex commands to quickly move from one brunch file to one of its related files. 

Want to open your user model? Type `:Bmodel user`. Need the corresponding unit test in a vertical split? Just go `:BVtest`.

##Installation

###Preferred method: Vundle
* Install with [vundle](https://github.com/gmarik/vundle)
* Add `Bundle 'drichard/vim-brunch'` to your vimrc
* Save and call `:BundleInstall`

### Manual installation
* Download zip/tarball and extract contents into your .vim directory

  **OR**

* Use git:

 ```
 git clone git://github.com/drichard/vim-brunch.git
 cd vim-brunch
 cp -R * ~/.vim
 ```

##Usage

Vim-brunch expects that you start Vim inside the root folder of your brunch project. When a brunch project has been detected the following commands are available:

###:Bmodel [name]
Opens the model for the current module or opens the model with the optionally given name.

###:Bview [name]
Opens the view for the current module.

###:Bcontroller [name]
Opens the controller for the current module.

###:Btemplate [name]
Opens the template for the current module.

###:Bstyle [name]
Opens the stylesheet for the current module.

###:Btest [name]
Opens the test for the current file. Inside a model this will open the unit test for a model, inside a view it opens the view\_test etc. Inside a template, for example, this command doesn't make much sense.

To open a specific test file *name* should be the filename of the module. The script will then try to figure out which test you want to open. For example, for `:Btest user` it would assume that you would like to open the test for the *user model*, whereas `:Btest user_view` will open the test for the *user view*.

In combination with the bang modifier this commands makes a handy shortcut for creating test files. `:Btest! todo_view` will create an empty test file in `test/views/todo_view_test.coffee`.

###:Bconfig
Opens the config file for the project.

###:Bindex
Opens index.html in app/assets/index.html.

###:Build [options]
Builds the project. Same as `brunch build`.

###:Bgenerate \<type\> \<name\> [options]
Generate files from template. Same as `brunch generate`.

###:Bdestroy \<type\> \<name\> [options]
Destroys changes made by `:Bgenerate`. Same as `brunch destroy`.

###:Btests [options]
Runs all tests for the current project. Same as `brunch test`. Requires brunch 1.3+.

##Features and Hints
* **Bang modifier:** The commands [model, view, controller, template, style, test] accept a *bang* modifier which creates a new file if it does not exist yet.

  ```
  :Bcontroller! home
  -> Would create app/controllers/home_controller.coffee if it isn't there yet.
  :Btest!
  -> Create the corresponding test file
  ```

* When called without an argument the commands with an optional *[name]* argument will open the appropriate file based on the file in the current buffer. However, you can specify a module name if you like to open an unrelated module.
  
  Inside app/models/todo.coffee:
  ```
  :Bview
  -> Opens app/views/todo_view.coffee
  ```
  
  Inside app/application.coffee:
  ```
  :Bview todolist
  -> Opens app/views/todolist_view.coffee
  ```

* **Auto completion:** All commands that accept an optional *[name]* argument offer context based auto completion. For example, `:Bmodel t<TAB>` would auto complete all models starting with 't'.

* **Split windows:** The navigation commands can also be called as `:BVmodel` or `:BSview` which will then open the file in a vertical or horizontal split window.

  ```
  :BStemplate user
  -> Opens app/views/templates/user.styl in horizontal split window.
  ```

* The plugin makes a lot of assumptions about how you name your files and where you put them. If you don't follow the brunch conventions all hell will break lose, the undead will rise again and not much will work really.


##Configuration

For now the plugin does not detect which brunch skeleton you are using, so by default it expects the standard directory structure with Backbone.js, CoffeeScript, Handlebars and Stylus.
If you want to change those settings, the following global variables are defined:

###let g:brunch_path_app='app'
The directory of the app folder.

###let g:brunch_path_test='test'
The directory of the test folder.

###let g:brunch_ext_script='coffee'
The extension for script files.

###let g:brunch_ext_stylesheet='styl'
The extension for stylesheets.

###let g:brunch_ext_template='hbs'
The extension for templates.

###let g:brunch_name_delim='_'
The delimiter in file names, _ or -.

###Example:
Inside your .vimrc:
```vimL
" Use Javascript and less for brunch.
let g:brunch_ext_script = 'js'
let g:brunch_ext_stylesheet = 'less'
```

##TODO

* Add support for `gf` in `require './home\_view'` statements
* Detect brunch settings based config.coffee
