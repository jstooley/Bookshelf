require './config/environment'


use Rack::MethodOverride
use UsersController
use BooksController
use AuthorsController
use GenresController
run ApplicationController
