#!/bin/sh

score=0

rm .build.txt
rm .run.txt
rm .test.txt

/home/user/.sdkman/candidates/gradle/current/bin/gradle build | tee .build.txt
/home/user/.sdkman/candidates/gradle/current/bin/gradle run | tee .run.txt
/home/user/.sdkman/candidates/gradle/current/bin/gradle test | tee .test.txt

if [ $? -eq 0 ] ; then 
    if [ -e ".build.txt" ]; then
        check=$(grep -o "BUILD SUCCESSFUL" .build.txt | wc -l)
        if [ $check != 0 ]; then 
	    score=$((score+20))
	fi
    fi
    if [ -e ".run.txt" ]; then
	check=$(grep -o -e "BUILD SUCCESSFUL" -e "Hello world." .run.txt | wc -l)
	if [ $check -eq 2 ]; then
	    score=$((score+20))
	fi
    fi
    if [ -e ".test.txt" ]; then
	check=$(grep -o -e "BUILD SUCCESSFUL" .test.txt | wc -l)
	if [ $check != 0 ]; then
	    score=$((score+20))
	fi
    fi
fi

if [ -d "repos" ]; then
    score=$((score+10))
fi

check=$(grep -o -e "plugins" -e "java"  build.gradle.kts | wc -l)
if [ $check -ge 2 ]; then
    score=$((score+8))
fi

check=$(grep -o -e "plugins" -e "application" build.gradle.kts | wc -l)
if [ $check -ge 2 ]; then
    score=$((score+7))
fi

check=$(grep -o -e "sourceCompatibility = JavaVersion.VERSION_1_7" -e "version" -e "targetCompatibility = JavaVersion.VERSION_1_7" build.gradle.kts | wc -l)
if [ $check -ge 3 ]; then
    score=$((score+5))
fi;


check=$(grep -o -e "uploadArchives" -e "flatDir" -e "dirs" -e "repos" build.gradle.kts | wc -l)
if [ $check -ge 4 ]; then
    score=$((score+5))
fi;

check=$(grep -o "mavenCentral()" build.gradle.kts | wc -l)
if [ $check -ge 1 ]; then
    score=$((score+5))
fi;

echo "FS_SCORE:$score%"
