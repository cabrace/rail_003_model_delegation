
Model Delegation
-----
Building upon the previous projects rails-{001,002}-* projects we extend the functionality to show how in the `Book` Model we can gain access to the
attributes of the `Author` Model as shown in the View because of the relational nature of the database. In this example the `Book` Model is a 'child' of the `Author` as it `belongs_to` `Author`. Here `Book` wants to access the attributes of the parent Model `Author`. This can be achieved through `delegation` of the child Model, to its Parent for the specified fields. In this example we want to call the relational field of `author.name` from the associated `book` relation, like: `book.author.name`. That way we have direct access to the parent's fields from the child.

> References:   
> [Initially Found Here](https://stackoverflow.com/questions/21201407/how-can-i-take-the-result-of-a-selection-from-a-list-and-put-it-into-another-tab)   
> [APIdock Documentation](https://apidock.com/rails/Module/delegate)  

In order to demonstrate this we will quickly apply a delegate method from the `Book` Model and delegate the necessary fields that we want to access.

``` ruby
# app/models/book.rb
class Book < ApplicationRecord
  belongs_to :author
  delegate :name, to: :author, prefix: true
end
```

Now that the `Book` Model looks like the above, we can now run the Rails console -- typing in `rails c` and test the following 
``` irb
# rails (c)onsole
b = Book.first
b.author.name
=> "Fyodor Dostoevsky"
```
And BOOM! We have direct access to the ':name' field related to the `Author` model from the `Book` side of the relation. The we we think of it as: the `Book` is delegating the specified attributes/fields of `:name` to the `:author` to return the results to `Book`. Look into the [APIdock REF](https://apidock.com/rails/Module/delegate) for more information on the prefix, which can apparently be changed to be custom paramaters.

This `b.author.name` information would **generally not** be accessible so easily, as we would have to perform a query on the `author.id` for the related books for that id using the Book model; however this method makes things a lot cleaner!

To expand upon this idea we can further extend the Books-Index-View page to show the corresponding Author information as it relates to a book ID, all withing
the relational model.

#### Show related Authors from the Books-View
```erb
<!-- app/views/books/index.html.erb -->
<p id="notice"><%= notice %></p>

<h1 class="title">Books</h1>

<div class="block">
  <%= link_to 'New Book +', new_book_path %>
</div>
<table class="table is-cell-bordered no-background">
  <thead>
    <th colspan="2" class="has-text-centered">
      Books
    </th>
    <th colspan="2" class="has-text-centered">
      Authors
    </th>

      <th colspan ="3" rowspan="2" style="vertical-align:middle;" class="has-text-centered">Actions</th>
    <tr>
      <th>ID</th>
      <th>Title</th>
      <th>ID</th>
      <th>Name</th>
    </tr>
  </thead>

  <tbody>
    <% @books.each do |book| %>
      <tr>
        <td><%= book.id %></td>
        <td><%= book.title %></td>
        <td><%= book.author_id %></td>
        <td><%= book.author.name %></td>
        <td><%= link_to 'Show', book %></td>
        <td><%= link_to 'Edit', edit_book_path(book) %></td>
        <td><%= link_to 'Destroy', book, method: :delete, data: { confirm: 'Are you sure?' } %></td>
      </tr>
    <% end %>
  </tbody>
</table>

<br>
```
With this View we can see on the left the populated `Book` Model data as it relates to the `Author` on the Book-Index-View page. But most importantly we can call
`book.author.name` directly from the book side of the relation!

As for the other side of the relaiotn `Author` to `Book` we do not need to do anything here because `Book` already belongs to `Author` and we can just call:

```irb
a = Author.first
a.books

=> #<ActiveRecord::Associations::CollectionProxy 
[#<Book id: 1, title: "Crime and Punishment", author_id: 1, ... >,
#<Book id: 2, title: "The Brothers Karamazov", author_id: 1,...>
irb(main):003:0>
```
to access all books related to a specific Author.

#### Show related Books from the Author-Show-View

```erb
<!-- app/views/authors/show.html.erb -->
<p id="notice"><%= notice %></p>

<div class="content">
  <div class="title">
    <%= @author.name %>
  </div>
  <div class="block">
    <%= link_to 'Back', authors_path %> |
    <%= link_to 'Edit Author', edit_author_path(@author) %> 
  </div>

  <p>
  <strong>Books:</strong>
  </p>
  <ol type="1">
    <% @author.books.each do |book| %>
      <li><%= book.title %></li>
    <% end %>
  </ol>
</div>
```
Using the above ERB code on the authors#show view page we can see their related books, without having to add a delegate method.

And that's that.
