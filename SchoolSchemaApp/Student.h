//
//  Student.h
//  SchoolSchemaApp
//
//  Created by Ashraf Jibrael on 5/2/13.
//  Copyright (c) 2013 Ashraf Jibrael. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Student : NSObject


@property (nonatomic,copy) NSString *firstName;
@property (nonatomic,copy) NSString *lastName;
@property (nonatomic) NSUInteger age;
@property (nonatomic, copy, readonly) NSString *studentId;
@property (nonatomic, getter = isAdmin) BOOL admin;


-(id)initWithStudentFirstName:(NSString*) firstName lastName:(NSString*) lastName age:(NSUInteger)age isAdmin:(BOOL)admin;

-(NSDictionary *)asJsonValue;


@end
