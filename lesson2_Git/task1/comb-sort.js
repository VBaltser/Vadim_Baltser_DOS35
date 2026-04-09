const combSort = (arr) => {
    const shrink = 1.3;
    let gap = arr.length;
    let swapped = true;
    while (gap > 1 || swapped) {
        gap = Math.max(1, Math.floor(gap / shrink));
        swapped = false;
        for (let i = 0; i + gap < arr.length; i++) {
            if (arr[i] > arr[i + gap]) {
                let temp = arr[i];
                arr[i] = arr[i + gap];
                arr[i + gap] = temp;
                swapped = true;
            }
        }
    }
    return arr;
};
