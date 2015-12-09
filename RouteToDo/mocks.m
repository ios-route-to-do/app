//
//  mocks.m
//  RouteToDo
//
//  Created by Juan Pablo Marzetti on 11/22/15.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "mocks.h"

Route *mockRoute1() {
    static Route *route = nil;
    
    if (!route) {
        route = [[Route alloc] init];
        
        Place *place1 = [[Place alloc] init];
        place1.name = @"Mikkeller Bar";
        place1.fullDescription = @"The first American outpost for the popular Denmark brewhouse, this 42-tapped beauty has both local and European brews on the list (including several exclusive-to-this-spot Mikkellers), plus, they even have a secret downstairs room devoted entirely to sour beers.";
        place1.address = @"55 Cyril Magnin St, San Francisco, CA 94102";
        place1.coordinates = CLLocationCoordinate2DMake(37.784719, -122.409203);
        place1.imageUrl = [NSURL URLWithString:@"http://33.media.tumblr.com/b6ed58627630bb8652ab6c3068be565b/tumblr_inline_n91a7hHpIp1qb3qcf.jpg"];
        
        Place *place2 = [[Place alloc] init];
        place2.name = @"Toronado";
        place2.fullDescription = @"Like beer, but hate people? Cool, so do the bartenders at this iconic Lower Haight establishment that boasts a seriously impressive tap list. Pro tip: know what you're ordering before the bartender looks at you. Or you look at him. Or the guy next to you looks at him. Literally, if anyone is looking anywhere, know what you're going to order. Also: have cash. Also also: make sure you hit their Annual Barleywine Festival.";
        place2.address = @"547 Haight St,San Francisco, CA 94117";
        place2.coordinates = CLLocationCoordinate2DMake(37.772055, -122.431186);
        place2.imageUrl = [NSURL URLWithString:@"http://i1142.photobucket.com/albums/n607/Gettingdark/Misc/IMG_20140507_214921_1_zpsk7jolnth.jpg"];
        
        Place *place3 = [[Place alloc] init];
        place3.name = @"Pi Bar";
        place3.fullDescription = @"This Mission spot not only opens at 3:14pm every day, but also serves a unique, basically never-repeating rotation of beers on tap that could very well make you the irrational one (math joke, +1!).";
        place3.address = @"1432 Valencia St,San Francisco, CA 94110";
        place3.coordinates = CLLocationCoordinate2DMake(37.750128, -122.420743);
        place3.imageUrl = [NSURL URLWithString:@"https://backoftheferry.files.wordpress.com/2014/10/sf-pi-bar.jpg"];
        
        
        route.title = @"The Beer Route";
        route.location = @"San Francisco";
        route.author = mockUser1();
        route.fullDescription = @"There are plenty of bars in SF where you can grab a beer, but less-plenty of bars in SF that you can call bona fide beer bars. Here're eight that we think not only make the cut, but make it better than anyone else.";
        route.imageUrl = [NSURL URLWithString:@"http://33.media.tumblr.com/b6ed58627630bb8652ab6c3068be565b/tumblr_inline_n91a7hHpIp1qb3qcf.jpg"];
        route.places = @[place1, place2, place3];
        route.usersCount = 257;
        route.categories = @[];
    }
    
    return route;
}

NSArray *mockRouteWithouthPlaces1Array() {
    NSMutableArray *templateRoutesArray = [NSMutableArray array];
    for(int i = 0; i < 12; i++)
    {
        [templateRoutesArray addObject:mockRoute1()];
    }
    
    return templateRoutesArray;
}

NSArray *mockRouteWithouthPlaces2Array() {
    static Route *templateRoute = nil;
    
    if (!templateRoute) {
        templateRoute = [[Route alloc] init];        
        templateRoute.title = @"All night long !";
        templateRoute.location = @"Oakland";
        templateRoute.author = mockUser1();
        templateRoute.usersCount = 450;
        templateRoute.imageUrl = [NSURL URLWithString:@"https://backoftheferry.files.wordpress.com/2014/10/sf-pi-bar.jpg"];
    }

    NSMutableArray *templateRoutesArray = [NSMutableArray array];
    for(int i = 0; i < 12; i++)
    {
        [templateRoutesArray addObject:templateRoute];
    }
    
    return templateRoutesArray;

}

User *mockUser1() {
    //should be inited with a dictionary
    static User *defaultUser = nil;
    if (!defaultUser) {
        defaultUser = [[User alloc] init];
        defaultUser.username = @"Matias Goleador";
        [defaultUser.ownRoutes addObjectsFromArray:mockRouteWithouthPlaces1Array()];
        defaultUser.profileImageUrl = [NSURL URLWithString:@"https://backoftheferry.files.wordpress.com/2014/10/sf-pi-bar.jpg"];
        [defaultUser.outings addObjectsFromArray:mockRouteWithouthPlaces2Array()];
        defaultUser.location = @"Mountain View";
        
    }
    
    return defaultUser;
}
