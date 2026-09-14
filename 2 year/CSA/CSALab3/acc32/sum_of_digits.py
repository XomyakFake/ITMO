def sum_of_digits(n: int) -> int:
    """Calculate the sum of the digits of a number"""
    total = 0
    n = abs(n)
    while n > 0:
        total += n % 10
        n //= 10
    return total


assert sum_of_digits(123) == 6
assert sum_of_digits(-456) == 15