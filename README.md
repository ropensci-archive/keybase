
`keybase` : Tools to Work with the 'Keybase' 'API'

'Keybase' (<https://keybase.io>) is a directory of people and public keys and provides methods for obtaining public keys, validating users and exchanging files and/or messages in a secure fashion. Tools are provided to search for and retrieve information about 'Keybase' users, retrieve and import user public keys and list and/or download files.

There's also a thin but useful R wrapper around many of they `keybase` command-line utility functions.

The following functions are implemented:

-   `kb_discover`: Check Keybase membership and retrieve basic user info
-   `kb_file_exists`: See if a file exists
-   `kb_get_public_keys`: Retrive the public key(s) for a given user
-   `kb_list_files`: List directory path contents in a Keybase user's public folder
-   `kb_lookup`: Retrieve info on Keybase user(s)
-   `kb_raw_url`: Turn a user + path into a Keybase "raw" URL
-   `kb_read_file`: Read a resource (file) from a Keybase public folder
-   `kb_cmd`: Execute a keybase command-line command
-   `kb_encrypt_file`: Encrypt a file
-   `kb_decrypt_file`: Decrypt a file
-   `kb_encrypt_msg`: Encrypt a message
-   `kb_decrypt_msg`: Decrypt a message
-   `kb_followers`: Get keybase followers
-   `kb_following`: Get who you're following on keybase
-   `kb_ping`: Test connectivity to the keybase server

### Installation

``` r
devtools::install_github("hrbrmstr/keybase")
```

### Usage

``` r
library(keybase)
library(tidyverse)

# current verison
packageVersion("keybase")
```

    ## [1] '0.1.0'

``` r
kb_ping()
```

    ## [1] TRUE

``` r
kb_discover(twitter=c("hrbrmstr", "_inundata", "briandconnelly"), github="bearloga")
```

    ## # A tibble: 4 × 17
    ##   service                                                                                                   thumbnail
    ##     <chr>                                                                                                       <chr>
    ## 1 twitter https://s3.amazonaws.com/keybase_processed_uploads/38131fa9393026d27f6d75f1b094cb05_200_200_square_200.jpeg
    ## 2 twitter https://s3.amazonaws.com/keybase_processed_uploads/cd9018fd484caa798769d9ebafa1b805_200_200_square_200.jpeg
    ## 3 twitter  https://s3.amazonaws.com/keybase_processed_uploads/476eef9fcc8b86ab4c0632fd0bc50705_200_200_square_200.png
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

### Safe(r) data sharing

``` r
kb_list_files("hrbrmstr", "data")
```

    ## # A tibble: 3 × 4
    ##    entry_name entry_type                                     entry_url                                       raw_url
    ##         <chr>      <chr>                                         <chr>                                         <chr>
    ## 1   Rlogo.png       file   https://keybase.pub/hrbrmstr/data/Rlogo.png   https://hrbrmstr.keybase.pub/data/Rlogo.png
    ## 2  mtcars.csv       file  https://keybase.pub/hrbrmstr/data/mtcars.csv  https://hrbrmstr.keybase.pub/data/mtcars.csv
    ## 3 mtcars.json       file https://keybase.pub/hrbrmstr/data/mtcars.json https://hrbrmstr.keybase.pub/data/mtcars.json

``` r
kb_file_exists("hrbrmstr", "index.md")
```

    ## [1] TRUE

``` r
kb_file_exists("https://hrbrmstr.keybase.pub/data/Rlogo.pngd")
```

    ## [1] FALSE

``` r
kb_raw_url("hrbrmstr", "data/Rlogo.png")
```

    ## [1] "https://hrbrmstr.keybase.pub/data/Rlogo.png"

``` r
kb_file_exists("hrbrmstr", "data/Rlogo.png")
```

    ## [1] TRUE

``` r
kb_file_exists(kb_raw_url("hrbrmstr", "data/Rlogo.png"))
```

    ## [1] TRUE

``` r
kb_read_file("hrbrmstr", "data/mtcars.csv")
```

    ##     mpg cyl  disp  hp drat    wt  qsec vs am gear carb
    ## 1  21.0   6 160.0 110 3.90 2.620 16.46  0  1    4    4
    ## 2  21.0   6 160.0 110 3.90 2.875 17.02  0  1    4    4
    ## 3  22.8   4 108.0  93 3.85 2.320 18.61  1  1    4    1
    ## 4  21.4   6 258.0 110 3.08 3.215 19.44  1  0    3    1
    ## 5  18.7   8 360.0 175 3.15 3.440 17.02  0  0    3    2
    ## 6  18.1   6 225.0 105 2.76 3.460 20.22  1  0    3    1
    ## 7  14.3   8 360.0 245 3.21 3.570 15.84  0  0    3    4
    ## 8  24.4   4 146.7  62 3.69 3.190 20.00  1  0    4    2
    ## 9  22.8   4 140.8  95 3.92 3.150 22.90  1  0    4    2
    ## 10 19.2   6 167.6 123 3.92 3.440 18.30  1  0    4    4
    ## 11 17.8   6 167.6 123 3.92 3.440 18.90  1  0    4    4
    ## 12 16.4   8 275.8 180 3.07 4.070 17.40  0  0    3    3
    ## 13 17.3   8 275.8 180 3.07 3.730 17.60  0  0    3    3
    ## 14 15.2   8 275.8 180 3.07 3.780 18.00  0  0    3    3
    ## 15 10.4   8 472.0 205 2.93 5.250 17.98  0  0    3    4
    ## 16 10.4   8 460.0 215 3.00 5.424 17.82  0  0    3    4
    ## 17 14.7   8 440.0 230 3.23 5.345 17.42  0  0    3    4
    ## 18 32.4   4  78.7  66 4.08 2.200 19.47  1  1    4    1
    ## 19 30.4   4  75.7  52 4.93 1.615 18.52  1  1    4    2
    ## 20 33.9   4  71.1  65 4.22 1.835 19.90  1  1    4    1
    ## 21 21.5   4 120.1  97 3.70 2.465 20.01  1  0    3    1
    ## 22 15.5   8 318.0 150 2.76 3.520 16.87  0  0    3    2
    ## 23 15.2   8 304.0 150 3.15 3.435 17.30  0  0    3    2
    ## 24 13.3   8 350.0 245 3.73 3.840 15.41  0  0    3    4
    ## 25 19.2   8 400.0 175 3.08 3.845 17.05  0  0    3    2
    ## 26 27.3   4  79.0  66 4.08 1.935 18.90  1  1    4    1
    ## 27 26.0   4 120.3  91 4.43 2.140 16.70  0  1    5    2
    ## 28 30.4   4  95.1 113 3.77 1.513 16.90  1  1    5    2
    ## 29 15.8   8 351.0 264 4.22 3.170 14.50  0  1    5    4
    ## 30 19.7   6 145.0 175 3.62 2.770 15.50  0  1    5    6
    ## 31 15.0   8 301.0 335 3.54 3.570 14.60  0  1    5    8
    ## 32 21.4   4 121.0 109 4.11 2.780 18.60  1  1    4    2

``` r
kb_read_file("hrbrmstr", "data/mtcars.json")
```

    ##                      mpg cyl  disp  hp drat    wt  qsec vs am gear carb
    ## Mazda RX4           21.0   6 160.0 110 3.90 2.620 16.46  0  1    4    4
    ## Mazda RX4 Wag       21.0   6 160.0 110 3.90 2.875 17.02  0  1    4    4
    ## Datsun 710          22.8   4 108.0  93 3.85 2.320 18.61  1  1    4    1
    ## Hornet 4 Drive      21.4   6 258.0 110 3.08 3.215 19.44  1  0    3    1
    ## Hornet Sportabout   18.7   8 360.0 175 3.15 3.440 17.02  0  0    3    2
    ## Valiant             18.1   6 225.0 105 2.76 3.460 20.22  1  0    3    1
    ## Duster 360          14.3   8 360.0 245 3.21 3.570 15.84  0  0    3    4
    ## Merc 240D           24.4   4 146.7  62 3.69 3.190 20.00  1  0    4    2
    ## Merc 230            22.8   4 140.8  95 3.92 3.150 22.90  1  0    4    2
    ## Merc 280            19.2   6 167.6 123 3.92 3.440 18.30  1  0    4    4
    ## Merc 280C           17.8   6 167.6 123 3.92 3.440 18.90  1  0    4    4
    ## Merc 450SE          16.4   8 275.8 180 3.07 4.070 17.40  0  0    3    3
    ## Merc 450SL          17.3   8 275.8 180 3.07 3.730 17.60  0  0    3    3
    ## Merc 450SLC         15.2   8 275.8 180 3.07 3.780 18.00  0  0    3    3
    ## Cadillac Fleetwood  10.4   8 472.0 205 2.93 5.250 17.98  0  0    3    4
    ## Lincoln Continental 10.4   8 460.0 215 3.00 5.424 17.82  0  0    3    4
    ## Chrysler Imperial   14.7   8 440.0 230 3.23 5.345 17.42  0  0    3    4
    ## Fiat 128            32.4   4  78.7  66 4.08 2.200 19.47  1  1    4    1
    ## Honda Civic         30.4   4  75.7  52 4.93 1.615 18.52  1  1    4    2
    ## Toyota Corolla      33.9   4  71.1  65 4.22 1.835 19.90  1  1    4    1
    ## Toyota Corona       21.5   4 120.1  97 3.70 2.465 20.01  1  0    3    1
    ## Dodge Challenger    15.5   8 318.0 150 2.76 3.520 16.87  0  0    3    2
    ## AMC Javelin         15.2   8 304.0 150 3.15 3.435 17.30  0  0    3    2
    ## Camaro Z28          13.3   8 350.0 245 3.73 3.840 15.41  0  0    3    4
    ## Pontiac Firebird    19.2   8 400.0 175 3.08 3.845 17.05  0  0    3    2
    ## Fiat X1-9           27.3   4  79.0  66 4.08 1.935 18.90  1  1    4    1
    ## Porsche 914-2       26.0   4 120.3  91 4.43 2.140 16.70  0  1    5    2
    ## Lotus Europa        30.4   4  95.1 113 3.77 1.513 16.90  1  1    5    2
    ## Ford Pantera L      15.8   8 351.0 264 4.22 3.170 14.50  0  1    5    4
    ## Ferrari Dino        19.7   6 145.0 175 3.62 2.770 15.50  0  1    5    6
    ## Maserati Bora       15.0   8 301.0 335 3.54 3.570 14.60  0  1    5    8
    ## Volvo 142E          21.4   4 121.0 109 4.11 2.780 18.60  1  1    4    2

``` r
# need (for now) to use the "raw" URL for things `rio::import()` can't natively read

kb_list_files("hrbrmstr", "data", pattern = ".*.png") %>% 
  select(raw_url)
```

    ## # A tibble: 1 × 1
    ##                                       raw_url
    ##                                         <chr>
    ## 1 https://hrbrmstr.keybase.pub/data/Rlogo.png

``` r
magick::image_read("https://hrbrmstr.keybase.pub/data/Rlogo.png")
```

    ##   format width height colorspace filesize
    ## 1    PNG   800    700       sRGB    70593

### Test Results

``` r
library(keybase)
library(testthat)

date()
```

    ## [1] "Sat Mar 18 08:40:54 2017"

``` r
test_dir("tests/")
```

    ## testthat results ========================================================================================================
    ## OK: 0 SKIPPED: 0 FAILED: 0
    ## 
    ## DONE ===================================================================================================================
