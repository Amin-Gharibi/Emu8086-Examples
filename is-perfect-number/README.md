# Question
Create an application to determine which elements of an array are perfect numbers and which are not. You can use a helper array for this purpose.
- First, set all the elements of the helper array to 0.
- Then, when you encounter a perfect number, update the corresponding index of the helper array to 1.
To check if a number is perfect or not, create a separate procedure (function).
***
A number is considered perfect if the sum of all its divisors (excluding the number itself) is equal to the number.
***
For example:
- 6 is a perfect number because its divisors (less than 6) are 1, 2, 3, and their sum is 6.
- However, 20 is not a perfect number because its divisors (less than 20) are 1, 2, 4, 5, 10, and their sum is 22.