//
//  SchoolPersonnel.h
//  SchoolSchemaApp
//
//  Created by Ashraf Jibrael on 5/2/13.
//  Copyright (c) 2013 Ashraf Jibrael. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SchoolPersonnel : NSObject

@property (nonatomic,copy) NSString *firstName;
@property (nonatomic,copy) NSString *lastName;
@property (nonatomic,copy) NSString *role;
@property (nonatomic, copy, readonly) NSString *personId;
@property (nonatomic, getter = isAdmin) BOOL admin;

-(id)initWithSchoolPersonnelFirstName:(NSString*) firstName lastName:(NSString*)lastName role:(NSString*)role isAdmin:(BOOL)admin;


@end
