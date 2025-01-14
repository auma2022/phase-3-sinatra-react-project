class ApplicationController < Sinatra::Base
  set :default_content_type, 'application/json'
  
  # Add your routes here
  # get "/posts", to: "posts#index"
  # get "/posts/new", to: "posts#new"
  # get "/posts/:id", to: "posts#show"
  # post "/posts", to: "posts#create"  # usually a submitted form
  # get "/posts/:id/edit", to: "posts#edit"
  # put "/posts/:id", to: "posts#update" # usually a submitted form
  # delete "/posts/:id", to: "posts#destroy"

  get "/books" do
    books = Book.all 
    books.to_json(include: :reviews) 
  end

  get "/books/" do
    book = Book.all(title: params[:title], author: params[:author], likes: params[:likes])
    book.to_json(include: :reviews)
  end

  
  get 'reviews/:id' do 
    review = Review.find(params[:id])
    review.to_json
  end

  #create a new book
  post "/books" do 
    new_book = Book.create(title: params[:title], author: params[:author], likes: params[:likes])
    new_book.to_json
  end

  #create a new review
  post '/books/:book_id/reviews' do 
    book = Book.find_by(id: params[:book_id])
    new_review = book.reviews.create(text: params[:text])
    new_review.to_json(include: :book)
   
  end

  #update book likes
  patch '/books/:id' do 
    book = Book.find_by(id: params[:id])
    book.update(likes: params[:likes])
    book.to_json(include: :reviews)
  end

  #delete book review
  delete '/reviews/:id' do 
    review = Review.find_by(id: params[:id])
    review.destroy
    review.to_json
  end
  post '/user/login' do
    user = User.find_by(name: params[:name], password: params[:password])
    if user.nil?
      response = {response: 'user not found'}.to_json
    else 
      user.to_json
    end 
  end

end
