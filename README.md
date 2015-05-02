# ConcurrentHashTable

This is a thread safe hash table implemented using hash bins and a resizable
array of Mutex locks. The idea is this, each item gets indexed to some bin
inside of the hash table. The only time there is non-atomic behavior in a hash
table is when there is contention on an item in the hash table (i.e. multiple
threads attempting to read or write on one entry). Because of this, it makes
little sense to lock all reads and writes to the hash table, instead, we only
lock when there is contention to a hash bin.

To reduce memory consumption, we use arrays in each bin so multiple hashes can
end up being in the same bin. Anytime we access that bin, we lock the array.

Instead of using a fixed size lock array, we rehash our locks array whenever we
need to resize the hash table. This makes the implementation scalable because
as the table grows in size, the probability of any given item colliding with
another item decreases, and since we are only locking on collisions, so does
our required amount of locking.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'concurrent_hash_table'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install concurrent_hash_table

## Usage

To use the concurrent hash table:

```ruby
threads = []
hash = ConcurrentHashTable::ConcurrentHashTable.new 20 # <- capacity

128.times do
  threads << Thread.start do
    key = SecureRandom.hex
    val = 'Hello, world!'
    hash[key] = val
  end
end

threads.map(&:join)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/concurrent_hash_table/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
