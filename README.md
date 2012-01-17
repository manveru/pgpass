# pgpass

This little library helps you finding, parsing, and using entries in .pgpass
files.

## Example usage

  entry = Pgpass.match(database: 'sample_db', user: 'manveru')
  DB = Sequel.connect(entry.to_url)

## License

MIT all the way, see the LICENSE file.
