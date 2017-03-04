
`keybase` : Tools to Ensure Data, Message and File Confidentiality and Integrity through the 'Keybase' 'API'

'Keybase' <https://keybase.io> is a directory of people and public keys and provides methods for obtaining public keys, validating users and exchanging files and/or messages in a secure fashion. Tools are provided to search for and retrieve information about 'Keybase' users, retrieve and import user public keys and list and/or download files.

The following functions are implemented:

-   `kb_discover`: Check Keybase membership and retrieve basic user info
-   `kb_get_public_keys`: Retrive the public key(s) for a given user
-   `kb_list_files`: List files/directories in a user's public folder
-   `kb_lookup`: Retrieve info on Keybase user(s)

### Installation

``` r
devtools::install_github("hrbrmstr/keybase")
```

### Usage

``` r
library(keybase)

# current verison
packageVersion("keybase")
```

    ## [1] '0.1.0'

``` r
kb_discover(twitter=c("hrbrmstr", "_inundata", "briandconnelly"), github="bearloga")
```

    ## # A tibble: 4 × 17
    ##   service                                                                                                   thumbnail
    ##     <chr>                                                                                                       <chr>
    ## 1 twitter https://s3.amazonaws.com/keybase_processed_uploads/38131fa9393026d27f6d75f1b094cb05_200_200_square_200.jpeg
    ## 2 twitter https://s3.amazonaws.com/keybase_processed_uploads/cd9018fd484caa798769d9ebafa1b805_200_200_square_200.jpeg
    ## 3 twitter https://s3.amazonaws.com/keybase_processed_uploads/338a884eaab8cde7da413e43c29f9805_200_200_square_200.jpeg
    ## 4  github https://s3.amazonaws.com/keybase_processed_uploads/63abb0621ada307ed2ef1b09d2e14a05_200_200_square_200.jpeg
    ## # ... with 15 more variables: username <chr>, uid <chr>, full_name <chr>, ctime <dbl>,
    ## #   public_key.key_fingerprint <chr>, public_key.bits <int>, public_key.algo <int>, remote_proofs.dns <list>,
    ## #   remote_proofs.generic_web_site <list>, remote_proofs.twitter <chr>, remote_proofs.github <chr>,
    ## #   remote_proofs.reddit <lgl>, remote_proofs.hackernews <chr>, remote_proofs.coinbase <chr>,
    ## #   remote_proofs.facebook <chr>

``` r
kb_discover(twitter=c("sckottie", "_inundata", "briandconnelly"), kb_usernames_only=TRUE)
```

    ## # A tibble: 3 × 2
    ##   service       username
    ##     <chr>          <chr>
    ## 1 twitter         sckott
    ## 2 twitter        karthik
    ## 3 twitter briandconnelly

``` r
kb_lookup("karthik")
```

    ## # A tibble: 1 × 12
    ##                                 id basics.username basics.ctime basics.mtime basics.id_version basics.track_version
    ## *                            <chr>           <chr>        <int>        <int>             <int>                <int>
    ## 1 ea14f1c4bd8b781c02d94c5599abc800         karthik   1402722848   1402722848                25                    6
    ## # ... with 6 more variables: basics.last_id_change <int>, basics.username_cased <chr>, profile.mtime <int>,
    ## #   profile.full_name <chr>, profile.location <chr>, profile.bio <chr>

``` r
kb_list_files("marcopolo")
```

    ## # A tibble: 12 × 4
    ##                entry_name entry_type                                            entry_url
    ##                     <chr>      <chr>                                                <chr>
    ## 1     construction_files/        dir    https://keybase.pub/marcopolo/construction_files/
    ## 2                  games/        dir                 https://keybase.pub/marcopolo/games/
    ## 3                  stuff/        dir                 https://keybase.pub/marcopolo/stuff/
    ## 4           trip-reports/        dir          https://keybase.pub/marcopolo/trip-reports/
    ## 5                website/        dir               https://keybase.pub/marcopolo/website/
    ## 6         Classy Dyno.mp4       file      https://keybase.pub/marcopolo/Classy%20Dyno.mp4
    ## 7        banana-bread.txt       file       https://keybase.pub/marcopolo/banana-bread.txt
    ## 8              id_rsa.pub       file             https://keybase.pub/marcopolo/id_rsa.pub
    ## 9              index.html       file             https://keybase.pub/marcopolo/index.html
    ## 10       loading demo.mov       file     https://keybase.pub/marcopolo/loading%20demo.mov
    ## 11 signal_fingerprint.txt       file https://keybase.pub/marcopolo/signal_fingerprint.txt
    ## 12                 slides       file                 https://keybase.pub/marcopolo/slides
    ## # ... with 1 more variables: raw_url <chr>

``` r
kb_list_files("marcopolo", pattern="\\.txt")
```

    ## # A tibble: 2 × 4
    ##               entry_name entry_type                                            entry_url
    ##                    <chr>      <chr>                                                <chr>
    ## 1       banana-bread.txt       file       https://keybase.pub/marcopolo/banana-bread.txt
    ## 2 signal_fingerprint.txt       file https://keybase.pub/marcopolo/signal_fingerprint.txt
    ## # ... with 1 more variables: raw_url <chr>

### Test Results

``` r
library(keybase)
library(testthat)

date()
```

    ## [1] "Sat Mar  4 12:36:29 2017"

``` r
test_dir("tests/")
```

    ## testthat results ========================================================================================================
    ## OK: 0 SKIPPED: 0 FAILED: 0
    ## 
    ## DONE ===================================================================================================================
