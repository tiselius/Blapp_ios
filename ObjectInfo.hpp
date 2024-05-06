#ifndef OBJECTINFO_HPP
#define OBJECTINFO_HPP

#include <opencv2/opencv.hpp>
using namespace cv;

class ObjectInfo {
public:
    double area;
    cv::Mat image;
    cv::Point center;
};

#endif // OBJECTINFO_HPP