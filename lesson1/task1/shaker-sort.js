const shakerSort = (arr) => {
    let left = 0;
    let right = arr.length - 1;
    while (left < right) {
        let swapped = false;
        for (let i = left; i < right; i++) {
            if (arr[i] > arr[i + 1]) {
                let temp = arr[i];
                arr[i] = arr[i + 1];
                arr[i + 1] = temp;
                swapped = true;
            }
        }
        right--;
        if (!swapped) break;
        swapped = false;
        for (let i = right; i > left; i--) {
            if (arr[i - 1] > arr[i]) {
                let temp = arr[i - 1];
                arr[i - 1] = arr[i];
                arr[i] = temp;
                swapped = true;
            }
        }
        left++;
        if (!swapped) break;
    }
    return arr;
};
