<p align="center">
  <img alt="gitleaks" src="https://raw.githubusercontent.com/zricethezav/gifs/master/gitleakslogo.png" height="70" />
</p>

Gitleaks Action provides a simple way to run gitleaks in your CI/CD pipeline.


### AS Workflow
To use this Github you need to enable Github Actions in your Repository.

```
Settings > Actions > Allow all Actions
```
Now you need to create an action in the action menu above.
Choose skip and set up a workflow yourself.
Copy and paste the following code in the new .yml file.

```
name: gitleaks

on: [push,pull_request]


jobs:
  gitleaks:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
      with:
        fetch-depth: '0'
    - name: gitleaks-action
      uses: spring-media/gitleaks-action@master
    - name: create gitleaks-report
      run: touch gitleaks-report.json
```
### You can export the report like this
```
  - name: Gitleaks report
      if: ${{ always() }}
      uses: actions/upload-artifact@v2
      with:
         name: gitleaks report
         path: gitleaks-report.json
```

### Using your own .gitleaks.toml configuration
Include a .gitleaks.toml in the root of your repo directory.

### NOTE!!!
You must use `actions/checkout` before the gitleaks-action step. If you are using `actions/checkout@v2` you must specify a commit depth other than the default which is 1. 

ex: 
```
    steps:
    - uses: actions/checkout@v2
      with:
        fetch-depth: '0'
    - name: gitleaks-action
      uses: spring-media/gitleaks-action@master
```

using a fetch-depth of '0' clones the entire history. If you want to do a more efficient clone, use '2', but that is not guaranteed to work with pull requests.   
