[1mdiff --git a/Gemfile b/Gemfile[m
[1mindex c2fd67c..0b4f6e8 100644[m
[1m--- a/Gemfile[m
[1m+++ b/Gemfile[m
[36m@@ -3,6 +3,7 @@[m [msource 'https://rubygems.org'[m
 gem 'bcrypt-ruby', '~> 3.0.0', require: 'bcrypt'[m
 gem 'bootstrap-sass', '2.3.0.1'[m
 gem 'coffee-rails', '4.1.0'[m
[32m+[m[32mgem 'dotenv-rails', '1.0.2'[m
 gem 'jbuilder', '2.2.12'[m
 gem 'jquery-rails', '3.1.3'[m
 gem 'pg', '0.18.1'[m
[36m@@ -10,3 +11,4 @@[m [mgem 'rails', '4.1.16'[m
 gem 'sass-rails', '4.0.5'[m
 gem 'sprockets', '2.12.3'[m
 gem 'uglifier', '2.7.1'[m
[32m+[m[32mgem 'wepay'[m
[1mdiff --git a/Gemfile.lock b/Gemfile.lock[m
[1mindex ec1dfc3..d06f836 100644[m
[1m--- a/Gemfile.lock[m
[1m+++ b/Gemfile.lock[m
[36m@@ -40,6 +40,9 @@[m [mGEM[m
       execjs[m
     coffee-script-source (1.12.2)[m
     concurrent-ruby (1.0.5)[m
[32m+[m[32m    dotenv (1.0.2)[m
[32m+[m[32m    dotenv-rails (1.0.2)[m
[32m+[m[32m      dotenv (= 1.0.2)[m
     erubis (2.7.0)[m
     execjs (2.7.0)[m
     hike (1.2.3)[m
[36m@@ -100,6 +103,7 @@[m [mGEM[m
     uglifier (2.7.1)[m
       execjs (>= 0.3.0)[m
       json (>= 1.8.0)[m
[32m+[m[32m    wepay (0.4.0)[m
 [m
 PLATFORMS[m
   ruby[m
[36m@@ -108,6 +112,7 @@[m [mDEPENDENCIES[m
   bcrypt-ruby (~> 3.0.0)[m
   bootstrap-sass (= 2.3.0.1)[m
   coffee-rails (= 4.1.0)[m
[32m+[m[32m  dotenv-rails (= 1.0.2)[m
   jbuilder (= 2.2.12)[m
   jquery-rails (= 3.1.3)[m
   pg (= 0.18.1)[m
[36m@@ -115,6 +120,7 @@[m [mDEPENDENCIES[m
   sass-rails (= 4.0.5)[m
   sprockets (= 2.12.3)[m
   uglifier (= 2.7.1)[m
[32m+[m[32m  wepay[m
 [m
 BUNDLED WITH[m
    1.16.1[m
