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

    cv::Mat identifyColor(cv::Mat image);
    cv::Mat identifyColor(cv::Mat image, int x, int y);
    cv::Mat identifyAllObjects(cv::Mat& image, int invert);
    int identifyAllObjectAreas(cv::Mat& image, int invert);
    void removeBackground(cv::Mat& image);
    cv::Mat readImage(const std::string& imgPath);

private:
    int contourThickness(cv::Mat image);
    std::vector<std::vector<cv::Point>> getContours(cv::Mat& image, int invert, int retr);
    int getAverageHSV(const cv::Mat& image, int x, int y);
    int getHSV(const cv::Mat image);
    cv::Mat createMask(const cv::Mat& inputImage, const cv::Scalar& lowerBound, const cv::Scalar& upperBound);
    cv::Mat applyMask(const cv::Mat& image, const cv::Mat& mask);
};
