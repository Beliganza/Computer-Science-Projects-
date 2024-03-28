# Author: Ganza Belise Aloysie Isingizwe
# Date: 03/02/2023
#Purpose: quicksort


def partition(the_list, p, r, compare_func):
    pivot = the_list[r]
    i = p - 1
    j = p
    while j < r:
        # swaping to keep items lower than pivot to the left
        if compare_func(the_list[j], pivot):
            i += 1
            the_list[i], the_list[j] = the_list[j], the_list[i]

        #incrementing j
        j += 1

    # swaping to place the pivot in the mid of items greater than or less than
    the_list[i + 1], the_list[r] = the_list[r], the_list[i + 1]
    return i + 1


def quick_sort(the_list, p, r, compare_func):
    # if the list has one item or 'less'
    if p <= r:
        q = partition(the_list, p, r, compare_func)
        quick_sort(the_list, p, q - 1, compare_func)
        quick_sort(the_list, q + 1, r, compare_func)


def sort(the_list, compare_func):
    quick_sort(the_list, 0, len(the_list) - 1, compare_func)
