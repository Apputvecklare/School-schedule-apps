//
//  SchemaOfCourse.h
//  SchoolSchemaApp
//
//  Created by Ashraf Jibrael on 5/2/13.
//  Copyright (c) 2013 Ashraf Jibrael. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SchemaOfCourse : NSObject

@property (nonatomic,copy) NSString * course_name;
@property (nonatomic,copy) NSString * task;
@property (nonatomic,copy) NSString * lesson_time;
@property (nonatomic,copy) NSString * teacher;
@property  (nonatomic) NSUInteger  local;
@property (nonatomic,copy) NSString * day;
@property (nonatomic,copy) NSString * date;
@property  (nonatomic) NSUInteger week;
@property (nonatomic,copy) NSString * klassNum;
@property  (nonatomic) NSUInteger year;
@property (nonatomic, copy, readonly) NSString *schemaId;
@property  (nonatomic) NSUInteger lessonNumber;

-(id)initWithCreatingScheduleOfCourses: (NSString*)course_name task:(NSString*)task lesson_time:(NSString*)lesson_time teacher:(NSString*)teacherName local:(NSUInteger)local day:(NSString*)day date:(NSString*)date week:(NSUInteger)week year:(NSUInteger)year klass: (NSString*)klassNum lessonNumber : (NSUInteger)lessonNumber;

-(NSDictionary *)asJsonValue;



@end
