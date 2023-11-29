
1. downlaod `DiLiGenT-MV` dataset from http://www.cs.columbia.edu/CAVE/databases/multiview/diligent.html, put the data into the `pmsData` folder.


# if there is some problem when loading the data, please revise the data path in mainBaseline.m:
```
datadir = ['../project1/pmsData/', dataName];
```
to adapt the different filepath in your computer.

# estimating surface normal with the original Least Square method, run the following command:
mainBaseline
the result is put into the LS_result folder.

# estimating surface normal with Least Square while considering the cast-shadow and high-specular effect:
mainBaseline_shadow_specular
the result is put into the selected_LS_result folder.
You can try different thereshold to get the best result, by revise the following code in selected_LS_PMS.m:
```
discard_corrupted_data_ratio = 0.2;
```

# estimating surface normal with PCA method, the implementation is based on the Robust PCA(https://github.com/dlaptev/RobustPCA/blob/master/RobustPCA.m):
mainBaseline_pca
the result is put into the pca_result folder.
