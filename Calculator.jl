# Simple Statistical Calculator in Julia

function mean(arr)
    return sum(arr) / length(arr)
end

function median(arr)
    sorted = sort(arr)
    n = length(arr)
    if isodd(n)
        return sorted[div(n + 1, 2)]
    else
        return (sorted[n÷2] + sorted[n÷2 + 1]) / 2
    end
end

function variance(arr)
    m = mean(arr)
    return sum((x - m)^2 for x in arr) / length(arr)
end

function stddev(arr)
    return sqrt(variance(arr))
end

function main()
    println("Welcome to Julia Stats Calculator!")
    print("Enter numbers separated by commas: ")

    input = readline()
    nums = parse.(Float64, split(input, ","))

    println("\nResults:")
    println("Numbers: ", nums)
    println("Mean: ", mean(nums))
    println("Median: ", median(nums))
    println("Variance: ", variance(nums))
    println("Standard Deviation: ", stddev(nums))
end

main()
