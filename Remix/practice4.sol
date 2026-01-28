// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FeatureToggle {
    bool public feature1Enabled;
    bool public feature2Enabled;

    // --- 1. 切换逻辑 (NOT 门) ---
    function toggleFeature1() public {
        // [修正]: 使用 ! (非运算符) 来取反
        // 等同于: if (feature1) feature1 = false; else feature1 = true;
        feature1Enabled = !feature1Enabled;
    }
    
    // --- 2. 全开检查 (AND 门) ---
    function allFeaturesEnabled() public view returns (bool) {
        // [修正]: 直接返回布尔表达式的结果
        // && (与): 只有两边都为 true，结果才是 true
        return feature1Enabled && feature2Enabled;
    }

    // --- 3. 任一开启检查 (OR 门) ---
    function anyFeatureEnabled() public view returns (bool) {
        // [修正]: 使用 || (或运算符)
        // || (或): 只要有一边为 true，结果就是 true
        return feature1Enabled || feature2Enabled;
    }
}