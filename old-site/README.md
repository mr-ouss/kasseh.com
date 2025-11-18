# 1. Contents

This repositiry contains the codebase of the website [http://kasseh.com](http://kasseh.com).

# 2. Bitbucket Pipelines

Every push to the `master` branch will automatically update www.kasseh.com.

In the Bitbucket repository, define and setup the following variables:

* AWS_ACCESS_KEY_ID
* AWS_SECRET_ACCESS_KEY
* S3_BUCKET
* DISTRIBUTION_ID

# 3. Manually Update

To update the website, run the below command

	     ./refresh.sh


This is my personal website, a single page, single screen responsive site template.
Makes heavy use of CSS animation (something I've been messing with a lot lately).

The scrolling mountainous background was derived from "Icefields" by Ryan Schroeder,
a talented photographer from Vancouver who graciously released it on Unsplash under
the CC0 license. Be sure to check out his other stuff over at flickr (link below)
as well as all the other kickass CC0-licensed images at Unsplash (unsplash.com).


## 4. The Scrolling Background

This relies entirely on CSS to do its thing, which is cool, but that makes
changing it a bit weird/tricky at first. You can still use pretty much any image
you want, but for best results make sure yours is:

- Horizontally tileable.
- Wide and short.
- About 1500px wide.
- Fades to a solid color either at the top of bottom (which is used to fill the empty space above or below your image).

Now, there are two ways to use it:

- with CSS, or
- with Sass.

#### 4.1. Using CSS

Look for this line in css/style.css (line 108 as of this writing):

			background: #348cb2 url("images/bg.jpg") bottom left;

and use it to set the page background color, URL, and placement of your image. It should be as close to 1500px wide as you can get it.

#### 4.2. Using Sass

* Set the value of $bg to the page background color, URL, and placement of your image.
* Change $bg-width if your image is something other than 1500px wide.


## 5. Credits

* Background Image: Ryan Schroeder via Unsplash (unsplash.com - CC0 licensed) "Icefields" (flickr.com/photos/ryanschroeder/11876741703)
* Icons: Font Awesome (fortawesome.github.com/Font-Awesome)

## 6. Created by

Quentin O. Kasseh | [www.kasseh.com](http://www.kasseh.com)