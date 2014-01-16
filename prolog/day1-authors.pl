author(terry_brooks).
author(diane_duane).

book(shanarra, terry_brooks).
book(unicorn, terry_brooks).
book(wizard, diane_duane).

author(Book, Author) :- book(Book, Author), author(Author).
