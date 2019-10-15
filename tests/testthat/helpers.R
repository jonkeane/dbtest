skip_env <- function(which = c("postgres", "mariadb")) {
  which = match.arg(which)

  if ("postgres" %in% which && Sys.getenv("DBTEST_DISABLE_PG") != "") {
    skip("Skipping tests that need a functioning Postgres backend.")
  }

  if ("mariadb" %in% which && Sys.getenv("DBTEST_DISABLE_MARIA") != "") {
    skip("Skipping tests that need a functioning MariaDB backend.")
  }

  # always skip on cran
  skip_on_cran()
}

