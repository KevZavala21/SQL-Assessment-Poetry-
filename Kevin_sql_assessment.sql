--a. How many poets from each grade are represented in the data?

SELECT COUNT(DISTINCT id), grade_id
FROM author
GROUP BY grade_id

--b. How many of the poets in each grade are Male and how many are female?

WITH genders AS(SELECT author.id, grade_id, CASE
							WHEN gender_id = 1 THEN 'Female'
							WHEN gender_id = 2 THEN 'Male'
							ELSE 'not_included' END AS studentgender
FROM author)

SELECT COUNT(author.id), author.grade_id, studentgender
FROM author
INNER JOIN genders
USING(id)
WHERE studentgender = 'Female' OR studentgender = 'Male'
GROUP BY author.grade_id, studentgender

--c. Do you notice any trends across all grades?

There are many more female students

--d. Which was the earliest grade in which NA appeared in greater numbers than male? Third grade

WITH genders AS(SELECT author.id, grade_id, CASE
							WHEN gender_id = 4 THEN 'NA'
							WHEN gender_id = 2 THEN 'Male'
							ELSE 'not_included' END AS studentgender
FROM author)

SELECT COUNT(author.id), author.grade_id, studentgender
FROM author
INNER JOIN genders
USING(id)
WHERE studentgender = 'NA' OR studentgender = 'Male'
GROUP BY author.grade_id, studentgender

--2.Which of these things do children write about more often? = Cats
--Which do they have the most to say about when they do? = cat poems
--dog poems = 2372, average char_count = 220

WITH dogpoems AS(SELECT id, text, char_count
FROM poem
WHERE text ILIKE '%dog%')

SELECT AVG(char_count), COUNT(id) AS dog_poems
FROM dogpoems

--cat poems = 2485, average char_count = 234

WITH catpoems AS(SELECT id, text, char_count
FROM poem
WHERE text ILIKE '%cat%')

SELECT COUNT(id) AS cats, AVG(char_count)
FROM catpoems

--Redo this in a single query

SELECT COUNT(text), AVG(char_count), 'dog' AS topic
FROM poem
WHERE text ILIKE '%dog%'
UNION
SELECT COUNT(text), AVG(char_count), 'cat' AS topic
FROM poem
WHERE text ILIKE '%cat%'

--3a. Start by writing a query to return each emotion in the database with it's average intensity and character count.
--emotion with highest character count? = anger
--emotion with lowest character count? = joy

SELECT AVG(intensity_percent) AS avg_intensity, AVG(char_count) AS avg_char_count,
poem_emotion.emotion_id, CASE 
							 WHEN emotion_id = 1 THEN 'Anger'
							 WHEN emotion_id = 2 THEN 'Fear'
							 WHEN emotion_id = 3 THEN 'Sadness'
							 ELSE 'Joy' END AS emotion
FROM poem_emotion
INNER JOIN poem
ON poem_emotion.poem_id = poem.id
GROUP BY poem_emotion.emotion_id
ORDER BY avg_char_count DESC

--3b.Convert the query you wrote in part 'a' into a CTE. Then find the 5 most intense poems 
--that express joy and whether they are to be longer or shorter than the average joy poem.

WITH intensejoy_poems AS(SELECT poem_id, intensity_percent, emotion_id, char_count
FROM poem_emotion
INNER JOIN poem
ON poem_emotion.poem_id = poem.id
WHERE emotion_id = 4
ORDER BY intensity_percent DESC
LIMIT 5)

SELECT poem_id, intensity_percent, CASE
									WHEN emotion_id = 4 THEN 'Joy'
									ELSE 'NA'
									END AS emotion, CASE 
									WHEN char_count < 129 THEN 'Shorter'
									WHEN char_count > 129 THEN 'Longer'
									END AS compared_avg
FROM intensejoy_poems

--3c. Classify poems as either 'short'(Less than 60 char_count), 'medium' (char_count 60-120) 
--or 'long' (char_count over 100). What is the most common emotion for each classification.
-- Long = joy, medium = joy, short = joy

WITH classification AS(SELECT poem_id, CASE
				WHEN emotion_id = 1 THEN 'anger'
				WHEN emotion_id = 2 THEN 'fear'
				WHEN emotion_id = 3 THEN 'sadness'
				WHEN emotion_id = 4 THEN 'joy'
				ELSE 'NA' END AS emotion, CASE
											WHEN poem.char_count > 120 THEN 'long'
											WHEN poem.char_count BETWEEN 60 AND 119 THEN 'medium'
											ELSE 'short' END AS poem_length
FROM poem_emotion
INNER JOIN poem
ON poem_emotion.poem_id = poem.id)
					

SELECT poem_length, emotion, COUNT(*) AS most_common
FROM classification 
GROUP BY emotion, poem_length
ORDER BY most_common DESC


--4. Compare the 5 shortest poems by 1st graders to the 5 shortest poems by 5th graders
--a.Is there any difference in intensity between the two groups?  What could this mean?
-- there is more intensity in 5th grade poems, could be due to them being older kids.

WITH grades AS(SELECT author.id, grade_id,CASE
							WHEN grade_id = 1 THEN '1st'
							WHEN grade_id = 5 THEN '5th'
							ELSE 'NA' END AS studentgrade
FROM author),

emotions AS(SELECT poem_id, intensity_percent, char_count, grade_id
		   FROM poem_emotion
		   INNER JOIN poem
		   ON poem_emotion.poem_id = poem.id
		   INNER JOIN author
		   ON poem.author_id = author.id
		   WHERE grade_id = 1 OR grade_id = 5
		   ORDER BY char_count ASC
		   LIMIT 10)

SELECT AVG(intensity_percent) AS avg_intensity, AVG(char_count) AS avg_length, studentgrade
FROM grades
INNER JOIN emotions
USING(grade_id)
WHERE studentgrade = '1st' OR studentgrade = '5th'
GROUP BY studentgrade

--4b. Who shows up more in the shortest for grades 1 and 5, males or females?
-- Males
WITH genders AS(SELECT char_count, poem.id, author_id, CASE 
									WHEN gender_id = 1 THEN 'female'
									WHEN gender_id = 2 THEN 'male'
									ELSE 'NA' END AS sex
FROM poem
INNER JOIN author
ON poem.author_id = author.id
AND (grade_id = 1 OR grade_id = 5)
ORDER BY char_count
LIMIT 10)

SELECT COUNT(*), sex
FROM genders
GROUP BY sex

--4c. What is the most common emotion for the shortest poems in grades 1 and 5
-- joy
WITH poem_count AS (SELECT char_count, poem.id, emotion_id, CASE 
									WHEN emotion_id = 1 THEN 'anger'
									WHEN emotion_id = 2 THEN 'fear'
									WHEN emotion_id = 3 THEN 'sadness'
									ELSE 'joy' END AS emotion
FROM poem
INNER JOIN poem_emotion
ON poem.id = poem_emotion.poem_id
ORDER BY char_count ASC
LIMIT 10)

SELECT COUNT(*), emotion
FROM poem_count
GROUP BY emotion

--5. Character count ('char_count') for these poems is inaccurate.  
--  You can use the LENGTH() function on the body of the poem to get the actual character count.
--5a. Use this function to find out how many of the poems were classified correctly

WITH poemlengths AS(SELECT poem.id, LENGTH(text) AS poem_length, char_count
FROM poem)

SELECT SUM(CASE WHEN poem_length = char_count THEN 1 END) AS accurate,
	   SUM(CASE WHEN poem_length <> char_count THEN 1 END) AS inaccurate
FROM poemlengths

--5b. What percentage of poems was the length accurately predicted?

WITH poemlengths AS(SELECT poem.id, LENGTH(text) AS poem_length, char_count
FROM poem),

length_accuracy AS(SELECT SUM(CASE WHEN poem_length = char_count THEN 1 END) AS accurate,
	   SUM(CASE WHEN poem_length <> char_count THEN 1 END) AS inaccurate
FROM poemlengths)

SELECT accurate::decimal/(accurate + inaccurate) AS accuracy
FROM length_accuracy