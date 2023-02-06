# SQL Assessment - Poetry by Kids

> **Note:** The data in this exercise is derived from the datasets found [here](https://github.com/whipson/PoKi-Poems-by-Kids). An academic paper describing the PoKi project can be found [here](https://arxiv.org/abs/2004.06188)
> The data is used for education purposes with permission from the maintainer.  

The data have been normalized to third normal form (3NF). Take care in choosing the correct primary and foreign key pairs to join on.

### Setup
1. Create a database named `PoetryKids` on your PostreSQL Server.
2. Right-click on the empty database and choose the `Restore` option. Navigate to the `poetrykids.tar` file by clicking on the ellipsis (`...`). Leave the defaults for all other options.

### ERD
![](./assets/PoetryKids_erd.png)


### Assessment
**Write SQL Queries to answer the questions below. Save your queries to a `.sql` script along with the answers (as comments) to the questions posed.**

1. The poetry in this database is the work of children in grades 1 through 5.  
    a. How many poets from each grade are represented in the data?  
    b. How many of the poets in each grade are Male and how many are Female? Only return the poets identified as Male or Female.  
    c. Do you notice any trends across all grades?
    d. Which was the earliest grade in which NA appeared in greater numbers than male?


2. Cats and dogs have been popular themes in poetry for children. Which of these things do children write about more often? Which do they have the most to say about when they do?
    a. Return the **total** number of poems, their **average character count** for poems that mention **cat(s)** and poems that mention **dog(s)** in either the title of body of the poem.
    b. Redo this in a single query.

3. Do longer poems have more emotional intensity compared to shorter poems?  
    a. Start by writing a query to return each emotion in the database with it's average intensity and character count.   
     - Which emotion is associated the longest poems on average?  
     - Which emotion has the shortest?  

    b. Convert the query you wrote in part 'a' into a CTE. Then find the 5 most intense poems that express joy and whether they are to be longer or shorter than the average joy poem.   

    c. Classify poems as either 'short'(Less than 60 char_count), 'medium' (char_count 60-120) or 'long' (char_count over 100). What is the most common emotion for each
    classification.


4. Compare the 5 shortest poems by 1st graders to the 5 shortest poems by 5th graders.  

	a. Is there any difference in intensity between the two groups?  What could this mean?
  b. Who shows up more in the shortest for grades 1 and 5, males or females?
  c. What is the most common emotion for the shortest poems in grades 1 and 5.  


5. Character count ('char_count') for these poems is inaccurate.  You can use the LENGTH() function on the body of the poem to get the actual character count.
  a. Use this function to find out how many of the poems were classified correctly.  
  b. What percentage of poems was the length accurately predicted?
  c. Save this data to a .csv and create a scatterplot in excel comparing the char_count provided with the actual length.
  NOTE: There is no need to revise earlier solutions with this updated information.  All previous questions will use the char_count field.

When you are finished, Email your SQL scripts, including answers, to me directly.
