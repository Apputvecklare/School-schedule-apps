//
//  SchoolPersonnel.m
//  SchoolSchemaApp
//
//  Created by Ashraf Jibrael on 5/2/13.
//  Copyright (c) 2013 Ashraf Jibrael. All rights reserved.
//

#import "SchoolPersonnel.h"

@implementation SchoolPersonnel

-(id)initWithSchoolPersonnelFirstName:(NSString*) firstName lastName:(NSString*)lastName role:(NSString*)role isAdmin:(BOOL)admin
{
    self = [super init];
    if (self) {
        
        self.firstName = firstName;
        self.lastName = lastName;
        self.admin = admin;
        self.role = role;
        self->_personId = [[NSUUID UUID] UUIDString];
        
        
    }
    
    return  self;
    
}

-(NSUInteger)hash
{
    return 37 * [self.personId hash];
}

-(BOOL)isEqual:(id)other
{
    // if other points to self - we are equal
    if(other == self){
        return YES;
    }
    
    // if other is not nil AND is member of same class as we (self)
    if(other && [other isMemberOfClass:[self class]]){
        // comapre animalId
        return [[other personId] isEqualToString:self.personId];
    }
    
    // we are not equal
    return NO;
}



@end
