//
//  Student.m
//  SchoolSchemaApp
//
//  Created by Ashraf Jibrael on 5/2/13.
//  Copyright (c) 2013 Ashraf Jibrael. All rights reserved.
//

#import "Student.h"

@implementation Student

-(NSDictionary *)asJsonValue
{
    NSMutableDictionary *selfAsJson = [[NSMutableDictionary alloc] init];
    
    selfAsJson[@"studentId"] = self.studentId;
    selfAsJson[@"firstName"] = self.firstName;
    selfAsJson[@"lastName"] = self.lastName;
    selfAsJson[@"age"] = @(self.age);
    selfAsJson[@"type"] = @"student";
    selfAsJson[@"isAdmin"] = @(self.admin);
    
    return selfAsJson;
}


-(id) init
{
    return [self initWithStudentFirstName:@"" lastName:@"" age:0 isAdmin:NO];
}


-(id)initWithStudentFirstName:(NSString*) firstName lastName:(NSString*) lastName age:(NSUInteger)age isAdmin:(BOOL)admin{
    
    self = [super init];
    if (self) {
        self.firstName =firstName;
        self.lastName = lastName;
        self.age = age;
        self.admin = admin;
        self->_studentId =[[NSUUID UUID] UUIDString];
    }
    return self;
}


-(NSString *)description
{
    return [NSString stringWithFormat:@"%@, %@,%@,%ld", self.studentId,self.lastName , self.firstName, (unsigned long)self.age];
}


-(NSUInteger)hash
{
    return 37 * [self.studentId hash];
}

-(BOOL)isEqual:(id)other
{
    
    if(other == self){
        return YES;
    }
    
    
    if(other && [other isMemberOfClass:[self class]]){
        return [[other studentId] isEqualToString:self.studentId];
    }
    
    return NO;
}


@end
