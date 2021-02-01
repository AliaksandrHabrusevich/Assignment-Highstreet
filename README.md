# FVQS

iOS app that allows users to keep track of their favourite quotes at FavQs (https://favqs.com).

### Features:
 - see random quote
 - browse and search through a list of public quotes
 - log in with existing FavQs account
 - sign up for a FavQs account
 - favourite or unfavourite quote
 - see quote details and tags
 - select tag to see a list of matching quotes

### Architecture
The application architecture follows the rules of Clean Architecture. Source code is separated between 3 layers:
 - Data
    This layer contains the code responsible for accessing the data. In our case we have repositories that encapsulate working with FavQs API.
 - Domain
    Here you can find use cases, models and interfaces for repositories. Use case describes an action that user can perform, like add/delete favourite.
 - Presentation
    It is UI layer based on MVVM pattern. Each screen is represented by three entities: View, ViewModel and Router. View is responsible for UI, ViewModel uses entities and use cases form Domain layer to achive screen functionality. Router takes responsibility about navigation between views. AppDependency class takes care about creation application components and establishment dependencies between them.

There are no third-party frameworks and libraries in the app. To run just open project in Xcode and press Run button :)
