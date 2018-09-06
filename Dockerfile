FROM ruby

WORKDIR /app

COPY . .

# install dependencies
RUN bundle

# run the tests
RUN cd goose_game && bundle && rspec

CMD ["bundle", "exec", "ruby", "game.rb"]
