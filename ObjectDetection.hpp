#include <opencv2/opencv.hpp>
#include <iostream>
using namespace cv;

class ObjectDetection {
public:
    cv::Mat identifyCenterObject(cv::Mat image);
    int identifyCenterObjectArea(cv::Mat image);

    cv::Mat findObject(cv::Mat image, int x, int y);
    int findObjectArea(cv::Mat image, int x, int y);

    cv::Mat identifyObject(cv::Mat image);
    void writeContourAll(cv::Mat& image);
    cv::Mat readImage(const std::string& imgPath);

private:
    std::vector<std::vector<cv::Point>> getContours(cv::Mat& image);
    int getAverageHSV(const cv::Mat& image);
    int getHSV(const cv::Mat image);
    cv::Mat createMask(const cv::Mat& inputImage, const cv::Scalar& lowerBound, const cv::Scalar& upperBound);
    cv::Mat applyMask(const cv::Mat& image, const cv::Mat& mask);
};
