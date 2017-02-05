//
//  PlacesAutocompleteVC.h
//  WuChu
//
//  Created by Luokey on 12/15/14.
//  Copyright (c) 2014 Luokey. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PlacesAutocompleteQuery;

@protocol PlacesAutocompleteVCDelegate <NSObject>

@optional

- (void)didSelectLocation:(NSString*)address latitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude;

@end


//@interface SearchDisplayController : UISearchDisplayController
//
//@end

@interface PlacesAutocompleteVC : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate>
{
    NSArray*                    searchResultPlaces;
    PlacesAutocompleteQuery*    searchQuery;
    
    BOOL                        shouldBeginEditing;
}

@property (strong, nonatomic) IBOutlet UISearchBar* searchBar;

@property (nonatomic, assign) id<PlacesAutocompleteVCDelegate> delegate;


@end