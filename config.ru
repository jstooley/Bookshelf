require './config/environment'


use Rack::MethodOverride
use UsersController
use BooksController
use AuthorsController
run ApplicationController
