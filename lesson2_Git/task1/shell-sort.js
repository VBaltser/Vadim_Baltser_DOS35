const shellSort = (arr) => {
    let gap = Math.floor(arr.length / 2);
    while (gap > 0) {
        for (let i = gap; i < arr.length; i++) {
            let key = arr[i];
            let j = i;
            while (j >= gap && arr[j - gap] > key) {
                arr[j] = arr[j - gap];
                j -= gap;
            }
            arr[j] = key;
        }
        gap = Math.floor(gap / 2);
    }
    return arr;
};
