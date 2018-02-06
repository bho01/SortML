# SortML
SortML is an iOS application that differentiates recyclable items and non-recyclable items. It achieves that using new machine learning capabilities that Apple has released recently at their conference WWDC in 2017.

As of now we are using an existing model called InceptionV3, which you can download from Apple.

A problem that people have is mindlessly throwing recyclables into trash bins. Surprisingly, a mere 10% of the American population know what is appropriate for recycling and what is not. Therefore, we created this app to assist those who do not know the difference.

Here is how SortML works:

* The user takes a photo using Apple's VideoCore API
* The photo is then registered in the InceptionV3 model in real-time
* The result is given and ranks confidence levels that the machine "predicts" what the object it is observing is
* It grabs data from a recyclable items database and matches it with the most confident prediction.
* The output is given and shows the user if the item is recyclable or not.

You can download this project and try it if you want.

![alt tag](https://github.com/bho01/SortML/blob/master/IMG_0261.PNG)

![alt tag](https://github.com/bho01/SortML/blob/master/IMG_0262.PNG)
