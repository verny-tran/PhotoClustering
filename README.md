<br/>
<p align="center" width="100%">
    <img width="15%" src="https://github.com/verny-tran/PhotoClustering/blob/main/Resources/Icon.png"> 
</p>

<h1 align="center"> PhotoClustering </h1>
<p align="center"> A take-home assignment project for SilverAI application. The topic is similar photo clustering. </p>

## Features
- [x] Import large batch of photos *(Up to `10.000` photos)*.
- [x] Multiple clustering approaches *(with a distance threshold of `10.0`)*.
- [x] Display the *first photo* of each clusters to the view.
- [x] Execution time results.

|  Import photos  |  Mode selection  |  Execution results  |  Groups  |
|      :----:     |      :----:      |       :----:        |  :----:  |
| ![](https://github.com/verny-tran/PhotoClustering/blob/main/Resources/Import.png) | ![](https://github.com/verny-tran/PhotoClustering/blob/main/Resources/Selection.png) | ![](https://github.com/verny-tran/PhotoClustering/blob/main/Resources/Result.png) | ![](https://github.com/verny-tran/PhotoClustering/blob/main/Resources/Groups.png) |

__Known issue:__ 

This app employed [**PHPickerViewController**](https://developer.apple.com/documentation/photokit/phpickerviewcontroller) of [**PhotoKit**](https://developer.apple.com/documentation/photokit) as it's image picker; nevertheless, a known issue has been identified: You can't import an amount of photos that is larger than `503` items, or else it'll be throttled (and yes, exactly `>503` images). I believe it's an *iOS bug* because the [Freeform](https://support.apple.com/en-vn/guide/iphone/iphb86e84e2b/ios) app also got the same issue, or it just could be due to my device. 

> A possible solution is to switch to [**PHImageManager**](https://developer.apple.com/documentation/photokit/phimagemanager) and use [`requestImage(for:)`](https://developer.apple.com/documentation/photokit/phimagemanager/1616964-requestimage). However, I will not implement it right now.

## Methodology

### Huge Photo Batch Loading

To optimize the loading of the image batch, we *shouldn't load the highest resolution* version of them of course. To load only the image's mini-sized thumbnails, we specified the *maximum number of pixels* that should be in the thumbnail in [**PHPickerViewControllerDelegate**](https://developer.apple.com/documentation/photokit/phpickerviewcontrollerdelegate) using [`kCGImageSourceThumbnailMaxPixelSize`](https://developer.apple.com/documentation/imageio/kcgimagesourcethumbnailmaxpixelsize) (here it is `300` pixels max). Pass the entire `downsampleOptions` dictionary to the constructor [`CGImageSourceCreateThumbnailAtIndex`](https://developer.apple.com/documentation/imageio/1465099-cgimagesourcecreatethumbnailatin) and retrieve it's thumbnail; proceed with the thumbnails only. Use a [`DispatchGroup`](https://developer.apple.com/documentation/dispatch/dispatchgroup) to optimize those procedures. The whole process is as follows:

```swift
let dispatchGroup = DispatchGroup()
let dispatchQueue = DispatchQueue(label: "com.verny.PhotoClustering")

let itemProviders = results.map { $0.itemProvider }
    .filter { $0.hasItemConformingToTypeIdentifier(UTType.image.identifier) }

itemProviders.forEach { itemProvider in
    dispatchGroup.enter()
    
    itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier) { url, error in
        if let error = error { Logger().error("itemProvider.loadFileRepresentation \(error.localizedDescription)") }
        
        guard let url = url else { dispatchGroup.leave(); return }
        
        let sourceOptions = [
            kCGImageSourceShouldCache: false,
            kCGImageSourceCreateThumbnailFromImageIfAbsent: true
        ] as CFDictionary
        
        guard let source = CGImageSourceCreateWithURL(url as CFURL, sourceOptions) else { dispatchGroup.leave(); return }
        
        let downsampleOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: 300,
        ] as CFDictionary
        
        guard let cgImage = CGImageSourceCreateThumbnailAtIndex(source, 0, downsampleOptions) else { dispatchGroup.leave(); return }
        
        dispatchQueue.sync {
            let image = UIImage(cgImage: cgImage)
            self.viewModel.images.append(image)
        }
        
        dispatchGroup.leave()
    }
}

dispatchGroup.notify(queue: .main) {
    DispatchQueue.main.async { self.processing() }
}
```

### Feature Print Observation

The similarity distance between photos is calculated using the `API`: [`computeDistance(_:to:)`](https://developer.apple.com/documentation/vision/vnfeatureprintobservation/3182823-computedistance) of  [**VNFeaturePrintObservation**](https://developer.apple.com/documentation/vision/vnfeatureprintobservation). The underling backbone of it is basically similar to that of the combination between [MobileNet](https://arxiv.org/abs/1704.04861) and [PCA](https://en.wikipedia.org/wiki/Principal_component_analysis), which simply computes the very basic [Euclidean distance](https://en.wikipedia.org/wiki/Euclidean_distance) between two feature print vectors, given by: 

$$
\Vert u-v \Vert = \sqrt{\sum_{i=1}^n (u_i - v_i)^2}
$$

While comparing the distance between two arbitrary vectors in **iOS 16** is questionable, measuring the distance between two *normalized* vectors in **iOS 17** is far more significant. In data analysis, a typical measure of vector similarity is the **cosine distance**, which is closely connected to the vector distance by the following formula, where *θ* is the angle between the two vectors *u* and *v*:

$$
distance = 1 - cos(\theta) = \frac{\Vert u-v \Vert^2}{2} = \frac{d^2}{2}
$$

- In **iOS 16**, a feature print is a *non-normalized* float vector having `2048` values. Typical distance values range between `0.0 ~ 40.0`.
- While in **iOS 17**, a feature print is a *normalized* float vector of length `768`. Distance value range between `0.0 ~ 2.0` (in my testing set, the highest distance was `1.4`).

Because the app *must support* users on **iOS 16** - which don’t have access to the latest [**Vision**](https://developer.apple.com/documentation/vision/) framework, so I did specify an earlier revision:

```swift
visionRequest.revision = VNGenerateImageFeaturePrintRequestRevision1
```

__Specified threshold:__ 

Because we stick with the [revision 1](https://developer.apple.com/documentation/vision/vngenerateimagefeatureprintrequestrevision1) of [**VNFeaturePrintObservation**](https://developer.apple.com/documentation/vision/vnfeatureprintobservation) which ranges from `0.0` to `40.0`. We took an empirical method to determine an adequate similarity criterion for our use case (removing duplicates or quasi-duplicates from a collection of photos). We combined images of very similar dog breeds with images of various cats, ducks, towns, human faces, and other dog breeds. Then we asked [**Vision**](https://developer.apple.com/documentation/vision) to calculate the distance between each pair of photographs, and we repeated the experiment with other datasets (a mix of similar and distinct pictures). 

Every time, we noticed that a cutoff value spreading between `9.0` and `11.0` could separate the cluster of similar pictures from the different ones. The ideal **threshold** will fall to around one-quarter of the maximum value (`40.0`), which in this case is `10.0±1.0`.

```swift
let threshold: Float = 10.0
```

## Approaches

### 1. Node Clustering

**Node Clustering**, also known as *Community Detection* is the process of starting with each node as its own cluster and merging clusters until a balancing point is reached.

![](https://github.com/verny-tran/PhotoClustering/blob/main/Resources/Graph.png)

**DISCUSSION:** The function's goal is to generate an **undirected graph** with vertices connected by *weighted edges* (which in this case is the distance of similarity between the photos). The *lower the edge value*, the *more similar* the vertices connected by that edge. This function creates *clusters* for the *specified graph*, with each cluster including vertices that are similar to one another.

The construction of the clusters is determined by the **threshold** value supplied as input. If the *weight of an edge* between two clusters divided by the *minimum weight of clusters* is *less than or equal* to the *tolerance threshold*, the two clusters are *combined into a single cluster*. By default, each vertex is a cluster with a weight of `1`.

### 2. Linear Marching

**Linear Marching** through all of the photographs, grouping similar neighbor photos together and *never turning it's head back*.

**IMPORTANT:** This approach results in *fragmented but similar clusters*, which is a *disadvantage* but offset by it's optimized *time complexity*.

#### Evaluation:

| Approach   | Time complexity | Benefits | Downsides |
|------------|-----------------|----------|-----------|
| Node Clustering | $$O(n^2)$$ | Precision, will works with all kind of input variations. Extendable, is a potential solution. | Timely execution. |
| Linear Marching | $$O(n)$$   | Fast, rapid. | Resulted in fragmented but similar clusters, unprecise. |

#### Performance:

These tests and records are performed on my device - an [iPhone XS Max](https://support.apple.com/en-us/111880).

| Amount of images | Node Clustering    | Linear Marching    |
|------------------|--------------------|--------------------|
| 10               | `1.0418` seconds   | `0.1875` seconds   |
| 100              | `101.8176` seconds | `2.2491` seconds   |
| 500              | Too long...        | `10.2574` seconds  |

## Data

I used the [**Stanford Dogs**](http://vision.stanford.edu/aditya86/ImageNetDogs) dataset, which contains about `≈20.000` photos classified into `120` breeds of dogs. There are *relatively few* photographs for each breed, and some are *duplicated*, which is a good reason to use it. The breeds I chose for the performance test include [Pekingese](https://en.wikipedia.org/wiki/Pekingese), [Shih-Tzu](https://en.wikipedia.org/wiki/Shih_Tzu), [Blenheim Spaniel](https://en.wikipedia.org/wiki/Cavalier_King_Charles_Spaniel) and [Papillon](https://en.wikipedia.org/wiki/Papillon_dog), which are all quite similar visually.

## Requirements
- **iOS** `16.0+`
- **Swift** `5.1+`
- **Xcode** `14.0+`

__Installation:__ This project doesn't contain any *package dependencies*; just simply register the bundle with your developer account and build it.

## License

**PhotoClustering** is available under the **MIT** license. See the `LICENSE` file for more info.
