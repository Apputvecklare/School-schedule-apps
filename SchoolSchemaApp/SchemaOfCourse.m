//
//  SchemaOfCourse.m
//  SchoolSchemaApp
//
//  Created by Ashraf Jibrael on 5/2/13.
//  Copyright (c) 2013 Ashraf Jibrael. All rights reserved.
//

#import "SchemaOfCourse.h"

@implementation SchemaOfCourse


- (id)init
{
    return [self initWithCreatingScheduleOfCourses:@"" task:@"" lesson_time:@"" teacher:@"" local:0 day:@"" date:@"" week:0 year:0000 klass:@"" lessonNumber:0];
}



-(id)initWithCreatingScheduleOfCourses: (NSString*)course_name task:(NSString*)task lesson_time:(NSString*)lesson_time teacher:(NSString*)teacherName local:(NSUInteger)local day:(NSString*)day date:(NSString*)date week:(NSUInteger)week year:(NSUInteger)year klass: (NSString*)klassNum lessonNumber : (NSUInteger)lessonNumber
{
    
    self = [super init];
    if (self) {
        self.course_name =course_name;
        self.lesson_time = lesson_time;
        self.task = task;
        self.teacher = teacherName;
        self.local = local;
        self.day = day;
        self.date = date;
        self.week = week;
        self.year = year;
        self.klassNum = klassNum;
        self.lessonNumber = lessonNumber;
        self->_schemaId =[[NSUUID UUID] UUIDString];
    }
    
    return self;
}



-(NSDictionary *)asJsonValue
{
    NSMutableDictionary *selfAsJson = [[NSMutableDictionary alloc] init];
    
    selfAsJson[@"schemaId"] = self.schemaId;
    selfAsJson[@"week"] = @(self.week);
    selfAsJson[@"date"] = self.date;
    selfAsJson[@"local"] = @(self.local);
    selfAsJson[@"day"] = self.day;
    selfAsJson[@"year"] = @(self.year);
    selfAsJson[@"teacher"] = self.teacher;
    selfAsJson[@"task"] = self.task;
    selfAsJson[@"lesson_time"] = self.lesson_time;
    selfAsJson[@"course_name"] = self.course_name;
    selfAsJson[@"klassNum"] = self.klassNum;
    selfAsJson[@"type"] = @"course";
    selfAsJson[@"lesson_Number"] = @(self.lessonNumber);
    return selfAsJson;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"Coures Name:%@, Task: %@,Lesson_Number:%lu ,date: %@, by the teacher :%@, Kl. %@, in the local nr. : %lu,", self.course_name, self.task,self.lessonNumber ,self.date,self.teacher,self.lesson_time,self.local];
}







-(NSUInteger)hash
{
    return 37 * [self.schemaId hash];
}

-(BOOL)isEqual:(id)other
{
    
    if(other == self){
        return YES;
    }
    
    
    if(other && [other isMemberOfClass:[self class]]){
        return [[other schemaId] isEqualToString:self.schemaId];
    }
    
    return NO;
}



@end
