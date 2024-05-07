#ifndef OBJECTDETECTION_HPP
#define OBJECTDETECTION_HPP

#include <opencv2/opencv.hpp>
#include <iostream>
using namespace cv;

class ObjectDetection {
public:
    cv::Mat identifyCenterObject(cv::Mat image);
    int identifyCenterObjectArea(cv::Mat image);
    std::string findCenterOfObject(cv::Mat image);

    cv::Mat findObject(cv::Mat image, int x, int y);
    int findObjectArea(cv::Mat image, int x, int y);

    cv::Mat getEdges(cv::Mat image);

    double getArea();
    cv::Mat getImage();
    cv::Point getCenter();

    void findObjectInfo(cv::Mat image, int x, int y);
    void centerObjectInfo(cv::Mat image);

private:
    double areaInfo;
    cv::Mat imageInfo;
    cv::Point centerInfo;

    cv::Scalar contourColor = cv::Scalar(222, 181, 255);
    void drawWeightedContour(cv::Mat image, std::vector<cv::Point> contour);
    std::vector<std::vector<cv::Point>> getContours(cv::Mat& image);
};

#endif // OBJECTDETECTION_HPP