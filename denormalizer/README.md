# denormalizer

## overview
![image](https://cloud.githubusercontent.com/assets/47808/11353814/56023de6-91fb-11e5-934c-41bdec5fcf7b.png)

## installation

```
$docker build -t denormalizer .
```
## use

```
$docker run  -v $(pwd):/usr/src/app -e ELASTIC_SEARCH=http://$(docker-machine ip default):9200  -it denormalizer python aggregated_resource.py
```

## output
```
...
Created R:CLLE-ES-DO6635-SA85619
  S:CLLE-ES-SA85625
I:CLLE-ES-DO6748
  S:CLLE-ES-SA85716
  S:CLLE-ES-SA86821
  S:CLLE-ES-SA85710
Created R:CLLE-ES-DO6748-SA85710
Created 316 resources
```
