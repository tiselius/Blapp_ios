#include <opencv2/opencv.hpp>
#include <iostream>
using namespace cv;

class ObjectDetection {
public:
    cv::Mat identifyObject(cv::Mat image);
    int identifyObjectTest(cv::Mat image);
    cv::Mat readImage(const std::string& imgPath);

private:
    void writeContourAll(cv::Mat image);
    void writeContourMask(cv::Mat image);
    void writeContour(cv::Mat image);
    int getAverageHSV(const cv::Mat image);
    int getHSV(const cv::Mat image);
    cv::Mat createMask(const cv::Mat& inputImage, const cv::Scalar& lowerBound, const cv::Scalar& upperBound);
    cv::Mat applyMask(const cv::Mat& image, const cv::Mat& mask);
};
