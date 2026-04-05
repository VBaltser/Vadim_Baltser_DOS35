const quickSort = (arr) => {
    const partition = (low, high) => {
        const pivot = arr[high];
        let i = low - 1;
        for (let j = low; j < high; j++) {
            if (arr[j] <= pivot) {
                i++;
                let temp = arr[i];
                arr[i] = arr[j];
                arr[j] = temp;
            }
        }
        let temp = arr[i + 1];
        arr[i + 1] = arr[high];
        arr[high] = temp;
        return i + 1;
    };

    const sort = (low, high) => {
        if (low < high) {
            const p = partition(low, high);
            sort(low, p - 1);
            sort(p + 1, high);
        }
    };

    sort(0, arr.length - 1);
    return arr;
};
