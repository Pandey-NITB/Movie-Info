
Movies Info iOS App(Using TMDB Api):

A simple project created using Swift to show the use of Core Data and a REST Api in an iOS application.

All movies information came from The Movie Database website (https://www.themoviedb.org/). They have this amazing API (https://developers.themoviedb.org/3/getting-started/introduction) that could be used by any one.

#Features:
 1-App has 4 tabs - Playing now, Trending, Search and Favourites.
 2- Offline support.
 3- user can share the movie.
 4- User can navigate to Movie details after clicking on any movie. In movie detais page user can bookmark and share the detail page deeplink as well.
 
 Here are some screenshots from the app. 
 
 1- Playing_Now page

   ![](https://github.com/Pandey-NITB/TMDB_Movies_Remote_CoreData/blob/main/Movies%20Info/Assets.xcassets/Screenshots/PN.imageset/PN.png)

 2- Favourites Page
 
   ![](https://github.com/Pandey-NITB/TMDB_Movies_Remote_CoreData/blob/main/Movies%20Info/Assets.xcassets/Screenshots/Fav.imageset/FM.png)
 
 
 3- Movie Detail Page
 
   ![](https://github.com/Pandey-NITB/TMDB_Movies_Remote_CoreData/blob/main/Movies%20Info/Assets.xcassets/Screenshots/MD.imageset/MD.png)
   
   
#Clean Architecture & App Info:

This app is implemented using clean architecture having routers, services and viewModels. Used Factory design pattern for ViewControllerFactory. 
Network layer(Generic) is designed in such a way that app can use any network client like alamofire as well with minimal changes Curretly used URLSession for getting the responses from TMDB APIs.
After receiving the api response, response will be saved locally using Core Data framework. So the app can be used offline as well including search also.
Used compositon for API Service.

For Images, Custom cache implemented which will work in LRU cacing mechanism.

#Steps To Run the App:
Download the zip file and open .xcodeproj. Build and run to install in simulator. 




