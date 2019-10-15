context("MariaDB")
library(RMariaDB)
skip("RMariaDB is currently segfaulting")

con <- DBI::dbConnect(
  RMariaDB::MariaDB(),
  dbname = "nycflights",
  host = "127.0.0.1",
  username = "travis",
  password = ""
)

con <- nycflights13_sql(con)

test_that("The fixture is what we expect", {
  expect_identical(
    dbListTables(con),
    c("airlines", "planes", "weather", "airports", "flights")
  )

  expect_identical(
    dbGetQuery(con, "SELECT * FROM airlines LIMIT 2"),
    data.frame(
      carrier = c("9E", "AA"),
      name = c("Endeavor Air Inc.", "American Airlines Inc."),
      stringsAsFactors = FALSE
    )
  )
})

DBI::dbDisconnect(con)

start_capturing()

con <- DBI::dbConnect(
  RMariaDB::MariaDB(),
  dbname = "nycflights",
  host = "127.0.0.1",
  username = "travis",
  password = "6c9FT%Kj"
)

dbGetQuery(con, "SELECT * FROM airlines LIMIT 2")
dbGetQuery(con, "SELECT * FROM airlines LIMIT 1")

DBI::dbDisconnect(con)

stop_capturing()


with_mock_db({
  con <- DBI::dbConnect(
    RMariaDB::MariaDB(),
    dbname = "nycflights",
    host = "127.0.0.1",
    username = "travis",
    password = "6c9FT%Kj"
  )

  test_that("Our connection is a mock connection", {
    expect_is(
      con,
      "DBIMockConnection"
    )
  })

  test_that("We can use mocks for dbGetQeury", {
    expect_identical(
      dbGetQuery(con, "SELECT * FROM airlines LIMIT 2"),
      data.frame(
        carrier = c("9E", "AA"),
        name = c("Endeavor Air Inc.", "American Airlines Inc."),
        stringsAsFactors = FALSE
      )
    )
  })

  test_that("We can use mocks for dbSendQuery", {
    result <- dbSendQuery(con, "SELECT * FROM airlines LIMIT 2")
    expect_identical(
      dbFetch(result),
      data.frame(
        carrier = c("9E", "AA"),
        name = c("Endeavor Air Inc.", "American Airlines Inc."),
        stringsAsFactors = FALSE
      )
    )
  })

  test_that("A different query uses a different mock", {
    expect_identical(
      dbGetQuery(con, "SELECT * FROM airlines LIMIT 1"),
      data.frame(
        carrier = c("9E"),
        name = c("Endeavor Air Inc."),
        stringsAsFactors = FALSE
      )
    )
  })


  test_that("Error handling", {
    expect_error(
      DBI::dbConnect(RSQLite::SQLite()),
      "There was no dbname, so I don't know where to look for mocks."
    )

    expect_error(
      DBI::dbConnect(RSQLite::SQLite(), dbname = ""),
      "There was no dbname, so I don't know where to look for mocks."
    )


    result <- dbSendQuery(con, "SELECT * FROM airlines LIMIT 2")
    expect_warning(
      dbFetch(result, n = 1),
      "dbFetch `n` is ignored while mocking databases."
    )


    dbDisconnect(con)
  })
})

# we can use a new path (and with a named argument)
with_mock_db({
  con <- DBI::dbConnect(RSQLite::SQLite(), dbname = "new_db")
  test_that("The connection has a new path", {
    expect_identical(con@path, "new_db")

  })

  test_that("We can use mocks from the new path", {
    expect_identical(
      dbGetQuery(con, "SELECT * FROM airlines LIMIT 3"),
      data.frame(
        carrier = c("9E", "AA", "AS"),
        name = c("Endeavor Air Inc.", "American Airlines Inc.", "Alaska Airlines Inc."),
        stringsAsFactors = FALSE
      )
    )
  })
})

